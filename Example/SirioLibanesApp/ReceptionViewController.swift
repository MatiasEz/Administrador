//
//  ReceptionViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 25/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseDatabase
import PKHUD
import MobileCoreServices

class ReceptionViewController: UIViewController, UIDocumentPickerDelegate, UITableViewDelegate, UITableViewDataSource {
   public var information : [AnyHashable: Any] = [:]
   public var pageName : String = "juanitoevento"
    
    @IBOutlet weak var sincronizeButton: UIButton!
    @IBOutlet weak var cargarDatos: UIButton!
    @IBOutlet weak var tableView: UITableView!
   var ref: DatabaseReference!
   var mapInvitados : [Invitado] = []

    override func viewDidLoad() {
      PKHUD.sharedHUD.contentView = PKHUDProgressView()
      PKHUD.sharedHUD.show()
      ref = Database.database().reference()
      self.tableView.delegate = self;
      self.tableView.dataSource = self;
      super.viewDidLoad()
      
      sincronizeButton.backgroundColor = .clear
      sincronizeButton.layer.cornerRadius = 20
      sincronizeButton.layer.borderWidth = 1
      sincronizeButton.layer.borderColor = UIColor.white.cgColor
      
      cargarDatos.backgroundColor = .clear
      cargarDatos.layer.cornerRadius = 20
      cargarDatos.layer.borderWidth = 1
      cargarDatos.layer.borderColor = UIColor.white.cgColor
    }
   
   override func viewWillAppear(_ animated: Bool) {
      self.getUserInfo()
      super.viewWillAppear(animated)
   }
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.mapInvitados.count;
      
   }
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "receptionCell") as! ReceptionTableViewCell
      let position = indexPath.row
      let currentInvitado = mapInvitados[position]
      cell.nameLabel.text = currentInvitado.fullname
      
      let variableIntCantidad = currentInvitado.cantidad
      let stringCantidad = "\(variableIntCantidad)"
      cell.quantityLabel.text = stringCantidad
      
      let variableIntMesa = currentInvitado.mesa
      let stringMesa = "\(variableIntMesa)"
      cell.tableNumberLabel.text = stringMesa
      
       if (currentInvitado.mail?.isEmpty ?? true) {
           cell.qrImage.isHidden = true
       } else {
           cell.qrImage.isHidden = false
       }
    
    
      
      if (currentInvitado.ingresado == true) {
         cell.presenceButton.setImage(UIImage(named: "ingresado"), for: .normal)
      } else {
         cell.presenceButton.setImage(UIImage(named: "noingresado"), for: .normal)
      }
      
      
      
      return cell

      
      
   }
   
    @IBAction func refreshDataAction(_ sender: Any) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){ self.tableView.reloadData()}
    }
    
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
      PKHUD.sharedHUD.show()
      let position = indexPath.row
      let currentInvitado = self.mapInvitados [position]
      if  (currentInvitado.ingresado == true) { currentInvitado.ingresado = false} else {currentInvitado.ingresado = true}
      var invitadoMap : [String:Any] = [:]
      invitadoMap["fullname"] = currentInvitado.fullname
      invitadoMap["ingresado"] = currentInvitado.ingresado
      invitadoMap["mesa"] = currentInvitado.mesa
      invitadoMap["cantidad"] = currentInvitado.cantidad
      if (!(currentInvitado.mail?.isEmpty ?? true)) {
         invitadoMap["mail"] = currentInvitado.mail
      }
      self.ref.child("Recepcion").child(self.pageName).child("\(position)").setValue(invitadoMap)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.tableView.reloadData()}
      self.saveValues()
   }
   
   func saveValues(){
      var newMapArray : [[String:Any]] = []
      for invitado in mapInvitados {
         var invitadoMap : [String:Any] = [:]
         invitadoMap["fullname"] = invitado.fullname
         invitadoMap["ingresado"] = invitado.ingresado
         invitadoMap["mesa"] = invitado.mesa
         invitadoMap["cantidad"] = invitado.cantidad
         if (!(invitado.mail?.isEmpty ?? true)) {
            invitadoMap["mail"] = invitado.mail
         }
         newMapArray.append(invitadoMap)
      }
      
      
      self.ref.child("Recepcion").child(self.pageName).setValue(newMapArray)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.tableView.reloadData()}
   }
   
   func getUserInfo()
   {
      ref.child("Recepcion").child(self.pageName).observe(.value, with: { (snapshot) in
         
         PKHUD.sharedHUD.hide()
         if let infoArray = snapshot.value as? [[String:Any]] {
            // todo ok, empezar a cargar resultados
            self.goUpdateInvitados(infoArray: infoArray)
         } else {
            PKHUD.sharedHUD.hide()
            let alert = UIAlertController(title: "Listado vacío", message: "No hay datos de recepción disponibles, puedes cargarlos usando la barra inferior.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
         }
      }) { (error) in self.displayError()
         //error
         return
      }
   }
   
   func goUpdateInvitados(infoArray: [[String:Any]]) {
      var invitadoArray : [Invitado] = []
      for infomap in infoArray {
         let invitado = Invitado (map:infomap)
         invitadoArray.append(invitado)
      }
      
      self.mapInvitados = invitadoArray.sorted {
         var string1 = $0.fullname
         var string2 = $1.fullname
         string1 = string1.capitalized
         string2 = string2.capitalized
         return  string1 < string2
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.tableView.reloadData()}
   }
   
   func displayError (message: String = "No pudimos obtener los datos de recepción, intente mas tarde.") {
      PKHUD.sharedHUD.hide()
      let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
   }
    @IBAction func loadReceptionData(_ sender: Any) {
      
      let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
      
      documentPicker.delegate = self
      present(documentPicker, animated: true, completion: nil)
      
    }
   

   func documentPicker(_ controller: UIDocumentPickerViewController,
                       didPickDocumentsAt urls: [URL]) {
      do {
         for url in urls {
            let str = String(decoding: try Data(contentsOf: url), as: UTF8.self)
            loadFileCsv(string: str)
            return
         }
         
      } catch {
         self.displayImportError()
      }
   }
   
   func loadFileCsv(string: String) {
      print(string)
      do {
         let csv = try CSVParser(content: string, delimiter: ";")
         self.loadJSON(string: try csv.toJSON())
         // get every row in csv
         
      } catch {
         self.displayImportError()
      }
      
      
   }
   
   func loadJSON(string: String?) {
      if let string = string, let dict = convertToDictionary(text: string) {
         self.goUpdateInvitados(infoArray: dict)
         self.saveValues()
      } else {
         self.displayImportError()
      }
      
   }
   
   func convertToDictionary(text: String) -> [[String: Any]]? {
      let newText = text.replacingOccurrences(of: "\\r", with: "")
      if let data = newText.data(using: .utf8) {
         do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
         } catch {
            self.displayImportError()
         }
      }
      return nil
   }
   
   func displayImportError () {
      let alert = UIAlertController(title: "Error", message: "Hubo un error en la carga del listado de recepción, por favor revisa que estes utilizando un archivo válido e intenta nuevamente", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
   }
   
    @IBAction func openCameraValidator(_ sender: Any) {
      let alert = UIAlertController(title: "No disponible", message: "Todavía no está disponible esta funcionalidad", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
   
   
    @IBAction func syncAssignment(_ sender: Any) {
      
      
      var allMesas : [String: [Any]] = [:]
      
      for invitado in self.mapInvitados {
         let mesaName = "Mesa \(invitado.mesa)"
         var array : [Any] = allMesas [mesaName] != nil ? allMesas [mesaName]! : []
         var map = ["nombre":invitado.fullname] as [AnyHashable : Any]
         map ["mail"] = invitado.mail ?? "desconocido"
         array.append(map)
         allMesas [mesaName] = array
      }
      
         self.ref.child("Asignaciones").child(self.pageName).setValue(allMesas)
         let alert = UIAlertController(title: "¡Asignacion actualizada!", message: "Se han cargado las asignaciones correspondientes a este evento, ya puedes habilitar la sección en la app", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
   }
}

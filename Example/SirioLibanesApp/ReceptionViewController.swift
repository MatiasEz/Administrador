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
import MYTableViewIndex;
import PureLayout
import BarcodeScanner

class ReceptionViewController: UIViewController, UIDocumentPickerDelegate, UITableViewDelegate, UITableViewDataSource, TableViewIndexDataSource, TableViewIndexDelegate, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
   public var information : [AnyHashable: Any] = [:]
   public var pageName : String = "juanitoevento"
    
   @IBOutlet weak var containerLateral: UIView!
   @IBOutlet weak var afueraButton: UIButton!
    @IBOutlet weak var todosButton: UIButton!
    @IBOutlet weak var adentroButton: UIButton!
    @IBOutlet weak var sincronizeButton: UIButton!
    @IBOutlet weak var cargarDatos: UIButton!
    @IBOutlet weak var tableView: UITableView!
   var ref: DatabaseReference!
   var fullInvitados : [Invitado] = []
   var invitados : [Invitado] = []
   var filterState = 0
   let colorSelected = UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.9)
   let colorUnselected = UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.5)

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
      
      let tableViewIndexController = TableViewIndexController(scrollView: tableView)
      tableViewIndexController.tableViewIndex.dataSource = self
      tableViewIndexController.tableViewIndex.delegate = self
      tableViewIndexController.tableViewIndex.font = UIFont.boldSystemFont(ofSize: 25.0)
      tableViewIndexController.tableViewIndex.removeFromSuperview()
      self.containerLateral.addSubview(tableViewIndexController.tableViewIndex);
      tableViewIndexController.tableViewIndex.autoPinEdgesToSuperviewEdges()
      tableViewIndexController.tableViewIndex.backgroundColor = UIColor.black
      tableViewIndexController.tableViewIndex.backgroundView.backgroundColor = UIColor.black
    }
   func indexItems(for tableViewIndex: TableViewIndex) -> [UIView] {
      let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
      return alphabet.map{ title -> UIView in
         let label = StringItem(text: title)
         label.font = label.font.withSize(30)
         label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         label.tintColor = UIColor.white
         return label
      }
   }
   
   func tableViewIndex(_ tableViewIndex: TableViewIndex, didSelect item: UIView, at index: Int) -> Bool {
      let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
      let letter = alphabet [index]
      var row : Int? = nil;
      var count = 0;
      for invitado in self.invitados {
         if (invitado.fullname.lowercased().hasPrefix(letter.lowercased())) {
            row = count
            break
         }
         count += 1
      }
      if let row = row {
         let indexPath = IndexPath(row: row, section: 0)
         tableView.scrollToRow(at: indexPath, at: .top, animated: true)
         return true
      }
      return false
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.getUserInfo()
      super.viewWillAppear(animated)
   }
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.invitados.count;
      
   }
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "receptionCell") as! ReceptionTableViewCell
      let position = indexPath.row
      let currentInvitado = invitados[position]
      cell.invitado = currentInvitado
      cell.nameLabel.text = currentInvitado.fullname
      
      let variableIntCantidad = currentInvitado.cantidad
      let stringCantidad = "\(variableIntCantidad)"
      cell.quantityLabel.text = stringCantidad
      
      let variableIntMesa = currentInvitado.mesa
      let stringMesa = "\(variableIntMesa)"
      cell.tableNumberLabel.text = stringMesa
      
       if (currentInvitado.mail?.isEmpty ?? true) {
         cell.qrImage.image = UIImage(named: "mailno")
       } else {
         cell.qrImage.image = UIImage(named: "mailyes")
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
      let currentInvitado = self.invitados [indexPath.row]
      self.changeState(for: currentInvitado, forceIngreso: false)
   }
   
   func changeState(for currentInvitado: Invitado, forceIngreso: Bool) {
      PKHUD.sharedHUD.show()
      let position = currentInvitado.position! - 1
      if  (currentInvitado.ingresado == true) { currentInvitado.ingresado = false} else {currentInvitado.ingresado = true}
      if (forceIngreso == true) {currentInvitado.ingresado = true;}
      var invitadoMap : [String:Any] = [:]
      invitadoMap["fullname"] = currentInvitado.fullname
      invitadoMap["ingresado"] = currentInvitado.ingresado
      invitadoMap["mesa"] = currentInvitado.mesa
      invitadoMap["cantidad"] = currentInvitado.cantidad
      if (!(currentInvitado.mail?.isEmpty ?? true)) {
         invitadoMap["mail"] = currentInvitado.mail
      }
      self.ref.child("Recepcion").child(self.pageName).child("\(position)").setValue(invitadoMap)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
         self.tableView.reloadData()
         self.getUserInfo()
      }
   }
   
   func saveValues(){
      var newMapArray : [[String:Any]] = []
      for invitado in fullInvitados {
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
    @IBAction func adentroFilter(_ sender: Any?) {
      self.invitados = self.fullInvitados.filter { $0.ingresado == true}
      self.tableView.reloadData()
      self.filterState = 1
      self.calculateRate()
      self.adentroButton.backgroundColor = colorSelected
      self.afueraButton.backgroundColor = colorUnselected
      self.todosButton.backgroundColor = colorUnselected
    }
    
    @IBAction func todosFilter(_ sender: Any?) {
      self.invitados = self.fullInvitados
      self.tableView.reloadData()
      self.filterState = 0
      self.calculateRate()
      self.adentroButton.backgroundColor = colorUnselected
      self.afueraButton.backgroundColor = colorUnselected
      self.todosButton.backgroundColor = colorSelected
    }
    
    @IBAction func afueraFilter(_ sender: Any?) {
      self.invitados = self.fullInvitados.filter { $0.ingresado == false}
      self.tableView.reloadData()
      self.filterState = 2
      self.calculateRate()
      self.adentroButton.backgroundColor = colorUnselected
      self.afueraButton.backgroundColor = colorSelected
      self.todosButton.backgroundColor = colorUnselected
    }
   
   func calculateRate () {
      let total = self.fullInvitados.count;
      let ingresados = self.fullInvitados.filter { $0.ingresado == true}.count
      let noIngresados = total - ingresados;
      
      self.adentroButton.setTitle("Adentro (\(ingresados))",for: .normal)
      self.afueraButton.setTitle("Afuera (\(noIngresados))",for: .normal)
      self.todosButton.setTitle("Todos (\(total))",for: .normal)
   }
    
    func goUpdateInvitados(infoArray: [[String:Any]]) {
        var invitadoArray : [Invitado] = []
        for infomap in infoArray {
            let invitado = Invitado (map:infomap)
            invitadoArray.append(invitado)
        }
      
      var fullDescriptionOfRecurrents = ""
        self.fullInvitados = invitadoArray.sorted {
            var string1 = $0.fullname
            var string2 = $1.fullname
            string1 = string1.capitalized
            string2 = string2.capitalized
            return  string1 < string2
        }
      
      
         var uniqueValues: [Invitado] = []
         for item in self.fullInvitados {
            if uniqueValues.contains(item) {
               let otherItem = uniqueValues[uniqueValues.firstIndex(of: item)!]
               fullDescriptionOfRecurrents += "Este mail está en dos cuentas: \(item.mail ?? "") \nLos nombres en conflicto son \(item.fullname ) y \(otherItem.fullname ?? "")\n\n"
            } else {
               uniqueValues += [item]
            }
         }
      
      if (!fullDescriptionOfRecurrents.isEmpty) {
         let fullText = "El mismo mail se está usando para muchos items de recepcion, por favor corrigelo: \n" + fullDescriptionOfRecurrents
         let textView = UITextView()
         textView.text = fullText
         
         let alert = UIAlertController(title: "Mails duplicados", message: nil, preferredStyle: .alert)
         textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
         let controller = UIViewController()
         
         textView.frame = controller.view.frame
         controller.view.addSubview(textView)
         
         alert.setValue(controller, forKey: "contentViewController")
         
         let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.8)
         alert.view.addConstraint(height)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         
         
         present(alert, animated: true, completion: nil)
      }
        
        var pos = 1
        for invitado in self.fullInvitados {
            invitado.position = pos
            pos += 1
        }
      switch self.filterState {
         case 0: self.todosFilter(nil);break
         case 1: self.adentroFilter(nil);break
         case 2: self.afueraFilter(nil);break
      default: break
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
         
       
         let stringLimpio = string.replacingOccurrences(of: ";;;;;", with: "")
         let csv = try CSVParser(content: stringLimpio, delimiter: ";")
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
      self.displayError(message: "Hubo un error en la carga del listado de recepción, por favor revisa que estes utilizando un archivo válido e intenta nuevamente")
   }
   
    @IBAction func openCameraValidator(_ sender: Any) {
      let viewController = BarcodeScannerViewController()
      viewController.codeDelegate = self
      viewController.errorDelegate = self
      viewController.dismissalDelegate = self
      
      present(viewController, animated: true, completion: nil)
    }
   
   func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
      for invitado in self.fullInvitados {
         if invitado.mail?.lowercased() == code.lowercased() {
            self.changeState(for: invitado, forceIngreso: true)
            controller.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Invitado aceptado", message: "El usuario marcado es \(invitado.fullname).\nSu mesa asignada es la \(invitado.mesa),\nLa cantidad asignada es: \(invitado.cantidad)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            if let row = self.invitados.index(of: invitado) {
               let indexPath = IndexPath(row: row, section: 0)
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                  self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
               }
            }
            return
         }
      }
      self.displayError(message: "El código QR escaneado no es válido o se trata de un usuario que no está asignado a este evento.")
      controller.dismiss(animated: true, completion: nil)
   }
   
   func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
      self.displayError(message: "No pudimos leer este código")
   }
   
   func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
      controller.dismiss(animated: true, completion: nil)
   }
   
    @IBAction func mailAsk(_ sender: Any) {
      let button = sender as! UIButton
      let cell = button.superview?.superview as! ReceptionTableViewCell
      let invitado = cell.invitado!

      var mailTitle = "Agregar email"
      var mailText = "Este invitado no tiene asignado ningún email y por tanto no puede acceder a la información del evento. Por favor ingresa el email del invitado:"
      
      if let mail = invitado.mail {
         mailTitle = "Modificar email"
         mailText = "Este invitado ya está asignado a este email: \(mail). Si deseas modificarlo ingresa el nuevo email en el campo inferior:";
      }
      
      let alertController = UIAlertController(title: mailTitle, message: mailText, preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         let firstTextField = alertController.textFields![0] as UITextField?
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes completar este campo para continuar")
            return
         }
         self.saveMail((firstTextField?.text)!,for: invitado);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Email del invitado"
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
   
   func saveMail(_ mail : String, for currentInvitado: Invitado) {
      PKHUD.sharedHUD.show()
      let position = currentInvitado.position! - 1
      var invitadoMap : [String:Any] = [:]
      invitadoMap["fullname"] = currentInvitado.fullname
      invitadoMap["ingresado"] = currentInvitado.ingresado
      invitadoMap["mesa"] = currentInvitado.mesa
      invitadoMap["cantidad"] = currentInvitado.cantidad
      invitadoMap["mail"] = mail
      self.ref.child("Recepcion").child(self.pageName).child("\(position)").setValue(invitadoMap)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
         self.tableView.reloadData()
         self.getUserInfo()
      }
   }
    
    @IBAction func syncAssignment(_ sender: Any) {
      
      
      var allMesas : [String: [Any]] = [:]
      
      for invitado in self.fullInvitados {
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

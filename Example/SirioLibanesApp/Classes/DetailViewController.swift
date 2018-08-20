//
//  DetailViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    public var currentState : Bool = false;
   var currentQRkey : String = ""
    var ref: DatabaseReference!
    

    
    override func viewDidLoad() {
        ref = Database.database().reference()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
      

        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let habilitado = self.information ["habilitada"] as! Bool? ?? false
      ref.child("Codigos").observeSingleEvent(of: .value, with: { (snapshot) in
         
         let userEventData = snapshot.value as? [AnyHashable : Any] ?? [:]
         for key in userEventData.keys {
            let myEventName = userEventData [key] as! String
            if (myEventName == self.pageName) {
               self.currentQRkey = key as! String;
               self.tableView.reloadData()
            }
         }
         
      }) { (error) in
         self.displayError()
      }
    }
    
    @IBAction func deleteCurrentEvent(_ sender: Any) {
      let alert = UIAlertController(title: "Borrar evento", message: "¿Está seguro de que desea borrar este evento? Se perderá toda la información, canciones recomendadas, asignaciones y datos de recepción del evento y ya no será accesible por ningún usuario.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
         self.ref.child("Eventos").child(self.pageName).removeValue()
         self.ref.child("Asignaciones").child(self.pageName).removeValue()
         self.ref.child("Musica").child(self.pageName).removeValue()
         self.ref.child("Recepcion").child(self.pageName).removeValue()
         if (self.currentQRkey.isEmpty == false) {
            self.ref.child("Codigos").child(self.currentQRkey).removeValue()
         }
         self.navigationController?.popToRootViewController(animated: true)
      }))
      
      alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1800.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
      cell.textfieldURL.text = self.information ["foto"] as? String
      cell.textfieldTitle.text = self.information ["titulo"] as? String
      cell.textfieldDescription.text = self.information ["descripcion"] as? String
      cell.textfieldPhone.text = self.information ["telefono"] as? String
      cell.textfieldTimestamp.text = String (describing: Int(self.information ["timestamp"] as! Double))
      cell.datePickerView?.date = Date(timeIntervalSince1970: TimeInterval(Double(cell.textfieldTimestamp.text!)!))
      cell.textfieldAddress.text = self.information ["lugar"] as? String
      cell.switchHabilitado.setOn((self.information ["habilitada"] as? Bool)!, animated: true)
      cell.textfieldQR.text = self.currentQRkey
      
      return cell
    }
   
   @IBAction func passAction(_ sender: Any) {
      
      let textfield = sender as! UITextField
      textfield.resignFirstResponder()
   }
    
    @IBAction func saveNewData(_ sender: Any)
    {
      let indexPath = IndexPath(row: 0, section: 0)
      let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
      self.ref.child("Eventos").child(pageName).setValue(self.currentDataEvent(cell))
      let newQRkey = cell.textfieldQR.text?.components(separatedBy: CharacterSet.alphanumerics.inverted)
         .joined()
      
      
      if (newQRkey != nil && (newQRkey?.isEmpty ?? true) == false ) {
         if (currentQRkey.isEmpty == false) {
            self.ref.child("Codigos").child(currentQRkey).removeValue()
         }
         self.ref.child("Codigos").child(newQRkey!).setValue(pageName)
      }
      
      let alert = UIAlertController(title: "¡Datos actualizados!", message: "Los datos fueron impactados correctamente, tus usuarios veran los datos modificados cuando abran la aplicacion.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.navigationController?.popViewController(animated: true)
      self.present(alert, animated: true, completion: nil)
      self.navigationController?.popToRootViewController(animated: true)
    }
   
   func currentDataEvent (_ cell : DetailTableViewCell) -> [AnyHashable:Any]
   {
      let event = ["titulo":cell.textfieldTitle.text!,
                   "descripcion":cell.textfieldDescription.text!,
                   "telefono":cell.textfieldPhone.text!,
                   "lugar":cell.textfieldAddress.text!,
                   "foto":cell.textfieldURL.text!,
                   "timestamp":Int(Double(cell.textfieldTimestamp.text!)!),
                   "habilitada":cell.switchHabilitado.isOn,
                   "invitados": self.information ["invitados"]!,
                   "redes": self.information ["redes"]!] as [String : Any]
      return event
   }
    
    func displayError (message: String = "No pudimos cambiar tu estado de confirmacion, intenta mas tarde.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "social" {
            let viewController: SocialViewController = segue.destination as! SocialViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
        
        if segue.identifier == "today" {
            let viewController: AssignmentViewController = segue.destination as! AssignmentViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
        
        if segue.identifier == "songs" {
            let viewController: SongsViewController = segue.destination as! SongsViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
      
      if segue.identifier == "reception" {
         let viewController: ReceptionViewController = segue.destination as! ReceptionViewController
         viewController.information = self.information
         viewController.pageName = self.pageName
      }
    }
   
   
}

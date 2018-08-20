//
//  InputViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import BarcodeScanner

class InputViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {

   
    
    var ref: DatabaseReference!
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
   var barcodeVC : BarcodeScannerViewController?
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var codeTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 20
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.cgColor
        
    }
   
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        self.codeTextfield.text = code
         redeem(nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
      self.displayError(message: "No conseguimos escanear este codigo")
    }
    
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      barcodeVC = self.childViewControllers [0] as? BarcodeScannerViewController
      if let barcodeVC = barcodeVC {
         barcodeVC.codeDelegate = self
         barcodeVC.errorDelegate = self
         barcodeVC.dismissalDelegate = self
         barcodeVC.messageViewController.view.alpha = 0;
         barcodeVC.reset()
      }
   }

    
    @IBAction func inputStarted(_ sender: Any) {
        getManualCode()
    }
    func getManualCode (){
        
        let alertController = UIAlertController(title: "Ingresa el código manualmente", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "De acuerdo", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField?
            if let textfield = firstTextField {
                self.codeTextfield.text = textfield.text
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Código"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func redeem(_ sender: Any?) {
        
        let redeemCode = codeTextfield.text!
        
        if (redeemCode.isEmpty) {
            displayError(message: "Debes ingresar el código que aparece en el mail de invitación")
            return
        }
        print (redeemCode)
        
        ref.child("Codigos").child(redeemCode).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventName = snapshot.value as? String
            if (eventName?.isEmpty ?? true) {
                self.displayError(message: "Ingresaste un código incorrecto")
            } else {
                self.pageName = eventName!
                self.assignKeyToUser(eventName!)
                self.assignUserToEvent()
                self.getEventDataAndContinue(eventName!)
            }
        }) { (error) in
            self.displayError(message: "No pudimos agregar tu evento, intenta mas tarde.")
        }
        
    }
    
    func assignKeyToUser (_ key : String)
    {
        let userId = Auth.auth().currentUser?.uid;
        if let unwrappedUserId = userId {
            
            
            ref.child("Users").child(unwrappedUserId).child("eventos").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let userEventData = snapshot.value as? [AnyHashable : Any]
                if var unwEventData = userEventData {
                    print (unwEventData.description)
                    unwEventData [key] = true
                    self.ref.child("Users").child(unwrappedUserId).child("eventos").setValue(unwEventData)
                } else {
                    self.ref.child("Users").child(unwrappedUserId).child("eventos").setValue([key:true])
                }
            }) { (error) in
                self.displayError()
            }
            
            
        } else {
            print("something went wrong")
        }
        
    }
    
    func assignUserToEvent (state: String = "indeterminado")
    {
        let userEmail = Auth.auth().currentUser?.email;
            if let unwrappedUserEmail = userEmail {
               guard let token = UserDefaults.standard.string(forKey: "nicknameKey") else {
                  displayError(message: "Por favor cierra sesión y vuelve a iniciar")
                  return
               }
                
            ref.child("Eventos").child(pageName).child("invitados").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let userEventData = snapshot.value as? [AnyHashable : Any]
                if var unwEventData = userEventData {
                    unwEventData [token] = state
                    self.ref.child("Eventos").child(self.pageName).child("invitados").setValue(unwEventData)
                } else {
                    self.ref.child("Eventos").child(self.pageName).child("invitados").setValue([token:state])
                }
            }) { (error) in
                self.displayError()
            }
            
        } else {
            print("something went wrong")
        }
    }
    
    
    func getEventDataAndContinue (_ key :String)
    {
        ref.child("Eventos").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventData = snapshot.value as? NSDictionary
            if let unwEventData = eventData {
                print (unwEventData.description)
                self.information = unwEventData as! [AnyHashable: Any]
                self.pageName = key
                self.goToDetailScreen()
            } else {
                self.displayError(message: "Tuvimos un problema obteniendo la información del evento, buscalo mas tarde en la pantalla principal.")
            }
        }) { (error) in
            self.displayError()
        }
    }
    
    func goToDetailScreen ()
    {
        self.performSegue(withIdentifier: "detailEvent", sender: self)
    }
    
    
    func displayError (message: String = "No pudimos agregar tu evento, intenta mas tarde") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailEvent" {
            let viewController: DetailViewController = segue.destination as! DetailViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
    }
}

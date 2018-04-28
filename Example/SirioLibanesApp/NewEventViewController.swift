//
//  NewEventViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 28/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {

   //OUTLETS Y PROPIEDADES
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var numeroDePaso : Int = 0
   
   //METODOS
   
   override func viewDidLoad() {
        super.viewDidLoad()
         //esto se ejecuta cuando se inicializa la clase
      self.inputTextField.autocorrectionType = .no
      self.inputTextField.becomeFirstResponder()
      self.inputTextField.text = ""
      
      self.continueButton.backgroundColor = .clear
      self.continueButton.layer.cornerRadius = 20
      self.continueButton.layer.borderWidth = 1
      self.continueButton.layer.borderColor = UIColor.white.cgColor
      
      self.changeText(title: "Titulo", description: "Esto se mostrará en el listado de eventos de tus usuarios")
    }

   @IBAction func continuePressAction(_ sender: Any) {
      
      if (self.inputTextField.text!.isEmpty) {
         let alert = UIAlertController(title: "Error", message: "Completa el campo para continuar", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
      }
      
      switch numeroDePaso {
      case 0:
         
         self.changeText(title:"Descripción", description: "Debe ser una descripción corta que se muestra como bajada en el listado de eventos")
         break
         
      case 1:
         
         self.changeText(title:"URL del Lugar", description: "URL que te dirige a la ubicación del evento en GoogleMaps")
         break
         
      case 2:
         
         self.changeText(title:"Telefono", description: "Contacto del cliente")
         break
         
      case 3:
         
         self.changeText(title:"Imagen de fondo", description: "URL de la imagen que se muestra como fondo en el detalle del evento")
         break
         
      case 4:
         
         self.changeText(title:"Fecha", description: "Fecha y hora en la que se va a producir el evento")
         break
         
      case 5:
         
         self.changeText(title:"Clave QR", description: "Codigo secreto que pueden ingresar manualmente los usuarios a la hora de escanearlo")
         break
      default:
         
         self.changeText(title:"Felicitaciones, terminaste", description: "Acabas de crear un evento nuevo!!")
         break
         
      }
      
      
      
      numeroDePaso = numeroDePaso + 1
      self.inputTextField.text = ""
      print("numero de paso: \(numeroDePaso)")
    }
   
   func changeText(title : String, description : String) {
      self.titleLabel.text = title
      self.descriptionLabel.text = description
   }
   
}

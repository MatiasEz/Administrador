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
    var socialNetworkStepStarted : Bool = false
    var currentSocialNetwork : String?
    var currentSocialStep : Int = 0
   
   //VARIABLES PARA GUARDAR INFORMACION DEL USUARIO
   var titulo : String?
   var descripcion : String?
   var foto : String?
   var timestamp : String?
   var telefono : String?
   var lugar : String?
   var codigoQR : String?
   var keyEvento : String?
   
   
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
      
      if (self.socialNetworkStepStarted == false) {
         self.requiredFieldsStep()
      } else {
         
         self.inputTextField.text = ""
 //esta linea de codigo se ejecuta cuando el usuario toca continuar tras haber completado la primer pregunta de una red social

         
         switch currentSocialStep {
            
         case 1:
            
            self.displaySecondQuestionForCurrentSocialNetwork()
            break
         
         case 2:
         
            self.displayThirdQuestionForCurrentSocialNetwork()
            break
         
         case 3:
            self.chooseNewSocialNetwork()
            break
            
         default:
            break
         }
         

      }
      
   }
   
   func requiredFieldsStep () {
      switch numeroDePaso {
      case 0:
         self.titulo = self.inputTextField.text
         self.changeText(title:"Descripción", description: "Debe ser una descripción corta que se muestra como bajada en el listado de eventos")
         break
         
      case 1:
         self.descripcion = self.inputTextField.text
         self.changeText(title:"URL del Lugar", description: "URL que te dirige a la ubicación del evento en GoogleMaps")
         self.inputTextField.keyboardType = .URL
         break
         
      case 2:
         self.lugar = self.inputTextField.text
         self.changeText(title:"Telefono", description: "Contacto del cliente")
         self.inputTextField.keyboardType = .phonePad
         break
         
      case 3:
         self.telefono = self.inputTextField.text
         self.changeText(title:"Imagen de fondo", description: "URL de la imagen que se muestra como fondo en el detalle del evento")
         break
         
      case 4:
         self.foto = self.inputTextField.text
         self.changeText(title:"Fecha", description: "Fecha y hora en la que se va a producir el evento")
         break
         
      case 5:
         self.timestamp = self.inputTextField.text
         self.changeText(title:"Clave QR", description: "Codigo secreto que pueden ingresar manualmente los usuarios a la hora de escanearlo")
         break
         
      case 6:
         self.codigoQR = self.inputTextField.text
         self.changeText(title:"ID de Base de Datos", description: "Esta es un ID sin espacios que sirve para identificar este evento en la base de datos")
         break
         
      default:
         self.keyEvento = self.inputTextField.text
         self.chooseNewSocialNetwork()
         break
         
      }
      
      numeroDePaso = numeroDePaso + 1
      self.inputTextField.text = ""
      print("numero de paso: \(numeroDePaso)")
   }
   
   func chooseNewSocialNetwork() {
      
      self.socialNetworkStepStarted = true
      
      let alert = UIAlertController(title: "Redes sociales", message: "Elige alguna red social que desees asociar a tu evento", preferredStyle: UIAlertControllerStyle.alert)
      //agrego acciones a la alerta
      alert.addAction(UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Facebook"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Instagram", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Instagram"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Twitter"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Ninguna", style: UIAlertActionStyle.default, handler: {(action) in
         self.finishEvent()
      }))
      self.present(alert, animated: true, completion: nil)
   }
   
   func displayFirstQuestionForCurrentSocialNetwork () {
      
      self.currentSocialStep = 1
      self.changeText(title:"\(self.currentSocialNetwork!) tag", description: "Ingresa con un texto que identifique la pagina de \(self.currentSocialNetwork!) ")
   }
   
   func displaySecondQuestionForCurrentSocialNetwork () {
      
      self.currentSocialStep = 2

      self.changeText(title:"\(self.currentSocialNetwork!) app link", description: " Este link permite abrir tu link en el contexto de la aplicacion de \(self.currentSocialNetwork!) ")
       }
   
   func displayThirdQuestionForCurrentSocialNetwork () {
      
      self.currentSocialStep = 3
      self.changeText(title:"\(self.currentSocialNetwork!) link", description: "Este link permite abrir tu link en el contexto del navegador de \(self.currentSocialNetwork!) ")
   }
   
   func changeText(title : String, description : String) {
      self.titleLabel.text = title
      self.descriptionLabel.text = description
   }
   
   func finishEvent () {
      
      let alert = UIAlertController(title: "Felicitaciones", message: "Has completado el evento con exito", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: {(action) in
         self.navigationController?.popViewController(animated: true)
         var viewController : HomeViewController?
         for vc in self.navigationController!.viewControllers {
            if (vc is HomeViewController) {
               viewController = vc as? HomeViewController
            }
         }
         viewController?.createPlaceholderEvent(map: self.placeholderEvent())
      }))
      self.present(alert, animated: true, completion: nil)
      return
   }
   
   func placeholderEvent () -> [AnyHashable:Any]
   {
      let tt = "placeholder"

      let placeholderSocial = ["link":tt,"name":tt,"applink":tt]

      let redes = ["facebook":placeholderSocial,"twitter":placeholderSocial,"instagram":placeholderSocial]

      let event = ["titulo":self.titulo!,
                   "descripcion":self.descripcion!,
                   "telefono":self.telefono!,
                   "lugar":self.lugar!,
                   "foto":self.foto!,
                   "timestamp":self.timestamp!,
                   "redes":redes,
                   "habilitada":false,
                   "key":self.keyEvento!] as [String : Any]

      return event
   }
   
}



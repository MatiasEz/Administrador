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
   public var datePickerView : UIDatePicker?
   public var timePickerView : UIDatePicker?

   
    var numeroDePaso : Int = 0
    var socialNetworkStepStarted : Bool = false
    var currentSocialNetwork : String?
    var currentSocialKey : String?
    var currentSocialStep : Int = 0
   var middleTimestamp : String?
   
   //VARIABLES PARA GUARDAR INFORMACION DEL USUARIO
   var titulo : String?
   var descripcion : String?
   var foto : String?
   var timestamp : String?
   var telefono : String?
   var lugar : String?
   var hashtag : String?
   var codigoQR : String?
   var keyEvento : String?
   var socialTag : String?
   var socialLink : String?
   var socialMaps : [String:Any] = [:]
   
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
      
      self.datePickerView = UIDatePicker()
      self.datePickerView!.datePickerMode = .date
      self.datePickerView!.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
     
      self.timePickerView = UIDatePicker()
      self.timePickerView!.datePickerMode = .time
      self.timePickerView!.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
      self.timePickerView!.locale = NSLocale(localeIdentifier: "en_GB") as Locale // using Great Britain for this example
      


      
      

      
      self.changeText(title: "Titulo", description: "Esto se mostrará en el listado de eventos de tus usuarios")
    }
   
   @objc func handleDatePicker() {
      
      
      
     
  
      let hour = Calendar.current.component(.hour, from: self.timePickerView!.date)
      let twoDigitHour = String(format: "%02d", hour)
      let minute = Calendar.current.component(.minute, from: self.timePickerView!.date)
      let twoDigitMinute = String(format: "%02d", minute)
      let year = Calendar.current.component(.year, from: self.datePickerView!.date)
      let month = Calendar.current.component(.month, from: self.datePickerView!.date)
      let twoDigitMonth = String(format: "%02d", month)
      let day = Calendar.current.component(.day, from: self.datePickerView!.date)
      let twoDigitDay = String(format: "%02d", day)
      let textoFecha = "\(twoDigitHour):\(twoDigitMinute) \(twoDigitDay)/\(twoDigitMonth)/\(year)"
      let fecha = "\(twoDigitDay)/\(twoDigitMonth)/\(year)"
      let hora = "\(twoDigitHour):\(twoDigitMinute)"
      let dateFormatterGet = DateFormatter()
      dateFormatterGet.dateFormat = "HH:mm dd/MM/yyyy"
 

    
      
      if (numeroDePaso == 5)
      { self.inputTextField.text = hora

      } else
      { self.inputTextField.text = fecha}
      
      
      guard let fechaCombinada = dateFormatterGet.date(from:textoFecha)else { return; }
      let timestampNumero = Int (fechaCombinada.timeIntervalSince1970)
      let timestampString = "\(timestampNumero)"
      self.middleTimestamp = timestampString
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
         
 //esta linea de codigo se ejecuta cuando el usuario toca continuar tras haber completado la primer pregunta de una red social

         
         switch currentSocialStep {
            
         case 1:
            self.socialTag  = self.inputTextField.text
            self.displaySecondQuestionForCurrentSocialNetwork()
            self.inputTextField.keyboardType = .default
            break
         
         case 2:
            self.socialLink  = self.inputTextField.text
            self.saveCurrentSocialData()
            self.chooseNewSocialNetwork()
            self.inputTextField.keyboardType = .default
            break
         
      
            default:
            break
         }
         
         self.inputTextField.text = ""

      }
      
   }
   
   func saveCurrentSocialData () {
      let mapSocial = ["link":self.socialLink,
                               "name":self.socialTag,
                              ]
      self.socialMaps [self.currentSocialKey!] = mapSocial
   }
   
   func requiredFieldsStep () {
      switch numeroDePaso {
      case 0:
         self.titulo = self.inputTextField.text
         self.changeText(title:"Descripción", description: "Debe ser una descripción corta que se muestra como bajada en el listado de eventos")
         self.inputTextField.keyboardType = .default
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
         self.inputTextField.keyboardType = .URL
         break
         
      case 4:
         self.foto = self.inputTextField.text
         self.changeText(title:"Hora del evento", description: "Hora en la que empezara el evento")
         self.inputTextField.keyboardType = .default
         self.inputTextField.inputView = self.timePickerView

break
         
         
      case 5:
         self.timestamp = self.middleTimestamp
         self.changeText(title:"Fecha", description: "Fecha en la que se va a producir el evento")
         self.inputTextField.keyboardType = .default
         self.inputTextField.inputView = self.datePickerView
         break
         
      case 6:
         self.timestamp = self.middleTimestamp
         self.changeText(title:"Clave QR", description: "Codigo secreto que pueden ingresar manualmente los usuarios a la hora de escanearlo")
         self.inputTextField.keyboardType = .default
         self.inputTextField.inputView = nil

         break
         
      case 7:
         self.codigoQR = self.inputTextField.text
         self.changeText(title:"ID de Base de Datos", description: "Esta es un ID sin espacios que sirve para identificar este evento en la base de datos")
         self.inputTextField.keyboardType = .default
         break
         
      case 8:
         self.hashtag = self.inputTextField.text
         self.changeText(title:"Hashtag", description: "dato usado para compartir informacion en tus redes")
         self.inputTextField.keyboardType = .default
         break

         
      default:
         self.keyEvento = self.inputTextField.text
         self.chooseNewSocialNetwork()
         break
         
      }
      
      numeroDePaso = numeroDePaso + 1
      self.inputTextField.reloadInputViews()
      self.inputTextField.resignFirstResponder()
      self.inputTextField.text = ""
      print("numero de paso: \(numeroDePaso)")
      self.inputTextField.becomeFirstResponder()
   }
   
   func chooseNewSocialNetwork() {
      
      self.socialNetworkStepStarted = true
      
      let alert = UIAlertController(title: "Redes sociales", message: "Elige alguna red social que desees asociar a tu evento", preferredStyle: UIAlertControllerStyle.alert)
      //agrego acciones a la alerta
      alert.addAction(UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Facebook"
         self.currentSocialKey = "facebook"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Instagram", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Instagram"
         self.currentSocialKey = "instagram"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Twitter"
         self.currentSocialKey = "twitter"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Snapchat", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Snapchat"
         self.currentSocialKey = "snapchat"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Youtube", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Youtube"
         self.currentSocialKey = "youtube"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Pagina web", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialNetwork = "Pagina web"
         self.currentSocialKey = "webpage"
         self.displayFirstQuestionForCurrentSocialNetwork()
      }))
      alert.addAction(UIAlertAction(title: "Terminar redes y crear evento", style: UIAlertActionStyle.destructive, handler: {(action) in
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
      self.changeText(title:"\(self.currentSocialNetwork!) link", description: "Este link permite abrir tu link en el contexto del navegador de \(self.currentSocialNetwork!) ")
   

      
   }


   
   func changeText(title : String, description : String) {
      self.titleLabel.text = title
      self.descriptionLabel.text = description
   }
   
   func finishEvent () {
      
      let alert = UIAlertController(title: "Felicitaciones", message: "Has completado el evento con exito", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: {(action) in
        
        self.performSegue(withIdentifier: "information", sender: self)

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

///      let redes = NO HARDCODEO

      let event = ["titulo":self.titulo!,
                   "descripcion":self.descripcion!,
                   "telefono":self.telefono!,
                   "lugar":self.lugar!,
                   "foto":self.foto!,
                   "timestamp":Int(self.timestamp!)!,
                   "qrkey":self.codigoQR!,
                   "hashtag":self.hashtag!,
                   "redes":self.socialMaps,
                   "habilitada":false,
                   "key":self.keyEvento!] as [String : Any]

      return event
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "information" {
         let viewController = segue.destination as! InformationViewController
         viewController.setUpCode(code: self.codigoQR!)
      }
   }
   
}



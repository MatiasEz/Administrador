//
//  NewEventViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 28/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController, UITextFieldDelegate {

   //OUTLETS Y PROPIEDADES
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var keyboardView: UIView!
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
    if UIDevice.current.userInterfaceIdiom == .pad {
        keyboardHeight.constant = 316
    } else if UIDevice.current.userInterfaceIdiom == .phone {
        keyboardHeight.constant = 216
    }
      self.inputTextField.autocorrectionType = .no
      self.inputTextField.becomeFirstResponder()
      self.inputTextField.text = ""
      
      self.continueButton.backgroundColor = .clear
      self.continueButton.layer.cornerRadius = 20
      self.continueButton.layer.borderWidth = 1
      self.continueButton.layer.borderColor = UIColor.white.cgColor
    
      self.backButton.backgroundColor = .clear
      self.backButton.layer.cornerRadius = 20
      self.backButton.layer.borderWidth = 1
      self.backButton.layer.borderColor = UIColor.white.cgColor
    
    
      self.datePickerView = UIDatePicker()
      self.datePickerView!.datePickerMode = .date
      self.datePickerView!.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
     
      self.timePickerView = UIDatePicker()
      self.timePickerView!.datePickerMode = .time
      self.timePickerView!.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
      self.timePickerView!.locale = NSLocale(localeIdentifier: "en_GB") as Locale // using Great Britain for this example
    
     self.inputTextField.delegate = self
   self.inputTextField.autocapitalizationType = .sentences
    
    }
   
   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let caracteresString = self.acceptCharacterForCurrentStep()
      let caracteresAceptables = CharacterSet(charactersIn: caracteresString)
      if string.rangeOfCharacter(from: caracteresAceptables) == nil && !string.isEmpty {
        self.showCaracterError()
         return false
      }
      return true
   }
   
   func acceptCharacterForCurrentStep () -> String {
      
      
      let caracteresLetrasYNumeros = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ñÑ"
      let caracteresSinEspacio = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_/:.-ñÑ"
      let caracteresConBarra = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ /ñÑ"
      let numeros = "01234567890+*#: "
      let letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_ñÑ"
      let letrasMinusculas = "abcdefghijklmnñopqrstuvwxyz"
      
      switch numeroDePaso {
         
         
      case 0 : return caracteresLetrasYNumeros
         //Titulo
      case 1 : return caracteresLetrasYNumeros
      //Descripcion
      case 2 : return caracteresSinEspacio
       //URL LUGAR
      case 3 : return numeros
         //TELEFONO
      case 4 : return caracteresSinEspacio
         //IMAGEN DE FONDO
      case 5 : return numeros
         //HORA
      case 6 : return caracteresConBarra
         //FECHA
      case 7 : return letrasMinusculas
         //CLAVEQR
      case 8 : return letras
         //IDBASEDEDATOS
      case 9 : return caracteresLetrasYNumeros
      //HASHTAG
      default: return caracteresLetrasYNumeros
      
      }
   }
    
   func showCaracterError() {
      let alert = UIAlertController(title: "Error", message: "El caracter que intentas agregar no está permitido en este campo. Solo se aceptan letras y números.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
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

    @IBAction func backPressAction(_ sender: Any) {
      
      if (numeroDePaso <= 0) {
         //si estoy en el paso cero y toco atras, salir del flow
         self.navigationController?.popViewController(animated: true)
         return
      }
      
      if (self.socialNetworkStepStarted == false) {
     numeroDePaso = numeroDePaso - 1
         self.requiredFieldsStep() } else {
         
         self.chooseNewSocialNetwork()
          }


   }
    
         
         
         
      
    
    @IBAction func continuePressAction(_ sender: Any) {
      
      if (self.inputTextField.text!.isEmpty) {
         let alert = UIAlertController(title: "Error", message: "Completa el campo para continuar", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
      }
      
      if (self.socialNetworkStepStarted == false) {
         numeroDePaso = numeroDePaso + 1
         self.saveInformationStep()
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
   
   func saveInformationStep () {
      switch numeroDePaso {
      case 0:
         break
         
      case 1:
         self.titulo = self.inputTextField.text
         break
         
      case 2:
         self.descripcion = self.inputTextField.text
         break
         
      case 3:
         self.lugar = self.inputTextField.text
         break
         
      case 4:
         self.telefono = self.inputTextField.text
         break
         
      case 5:
         self.foto = self.inputTextField.text
         break
         
      case 6:
         self.timestamp = self.middleTimestamp
         break
         
      case 7:
         self.timestamp = self.middleTimestamp
         break
         
      case 8:
         self.codigoQR = self.inputTextField.text
         break
         
      case 9:
         self.keyEvento = self.inputTextField.text
         break
         
      case 10:
         self.hashtag = self.inputTextField.text
         break
         
      default:
         break
      }
   }
   
   
   
   func requiredFieldsStep () {
      
      self.inputTextField.text = ""
      
      switch numeroDePaso {
         
      case 0:
         self.changeText(title: "Titulo", description: "Esto se mostrará en el listado de eventos de tus usuarios")
         self.inputTextField.keyboardType = .default
         self.inputTextField.text = self.titulo

         break
         
      case 1:
         self.changeText(title:"Descripción", description: "Debe ser una descripción corta que se muestra como bajada en el listado de eventos")
         self.inputTextField.autocapitalizationType = .sentences
         self.inputTextField.keyboardType = .default
         self.inputTextField.text = self.descripcion
         break
         
      case 2:
         self.changeText(title:"URL del Lugar", description: "URL que te dirige a la ubicación del evento en GoogleMaps")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .URL
         self.inputTextField.text = self.lugar
         break
         
      case 3:
         self.changeText(title:"Telefono", description: "Contacto del cliente")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .phonePad
         self.inputTextField.text = self.telefono
         break
         
      case 4:
         self.changeText(title:"Imagen de fondo", description: "URL de la imagen que se muestra como fondo en el detalle del evento")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .URL
         self.inputTextField.inputView = nil
         self.inputTextField.text = self.foto
         break
         
      case 5:
         self.changeText(title:"Hora del evento", description: "Hora en la que empezara el evento")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .default
         self.inputTextField.inputView = self.timePickerView
         self.handleDatePicker()
         break
         
      case 6:
         self.changeText(title:"Fecha", description: "Fecha en la que se va a producir el evento")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .default
         self.inputTextField.inputView = self.datePickerView
         self.handleDatePicker()
         break
         
      case 7:
         self.changeText(title:"Clave QR", description: "Codigo secreto que pueden ingresar manualmente los usuarios a la hora de escanearlo")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .default
         self.inputTextField.inputView = nil
         self.inputTextField.text = self.codigoQR

         break
         
      case 8:
         self.changeText(title:"ID de Base de Datos", description: "Esta es un ID sin espacios que sirve para identificar este evento en la base de datos")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .default
         self.inputTextField.text = self.keyEvento
         break
         
      case 9:
         self.changeText(title:"Hashtag", description: "dato usado para compartir informacion en tus redes")
         self.inputTextField.autocapitalizationType = .none
         self.inputTextField.keyboardType = .default
         self.inputTextField.text = self.hashtag
         break

         
      default:
         self.chooseNewSocialNetwork()
         break
         
      }
      
      self.inputTextField.reloadInputViews()
      self.inputTextField.resignFirstResponder()
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
      alert.addAction(UIAlertAction(title: "Cancelar el evento", style: UIAlertActionStyle.destructive, handler: {(action) in
         self.navigationController?.popViewController(animated: true)
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



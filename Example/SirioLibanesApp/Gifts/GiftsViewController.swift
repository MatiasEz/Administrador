//
//  ViewController.swift
//  SirioLibanesApp
//
//  Created by federico0812 on 02/04/2018.
//  Copyright (c) 2018 federico0812. All rights reserved.
//

import UIKit
import FirebaseDatabase
import PKHUD

class GiftViewController: UIViewController, UITableViewDataSource {
   
   public var information : [AnyHashable: Any] = [:]
   public var pageName : String = ""
   var items : [Gifts] = []
   var ref: DatabaseReference!
   var dataDictionary : [String:Any] = [:]
   var redesMap : [String: Any]?
   var currentSocialKey : String = ""
   
    
    
    @IBOutlet weak var addRedSocialButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editingDidBegin(_ sender: Any) {
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 216, right: 0)

    }
    override func viewDidLoad() {
        self.addRedSocialButton.backgroundColor = .clear
        self.addRedSocialButton.layer.cornerRadius = 20
        self.addRedSocialButton.layer.borderWidth = 1
        self.addRedSocialButton.layer.borderColor = UIColor.white.cgColor

      ref = Database.database().reference()
      super.viewDidLoad()
      

      self.tableView.dataSource = self;
      
      self.redesMap = self.information ["gifts"] as? [String: Any] ?? [:]
      self.addRedSocial(key: "blue", displayName: "Azul")
      self.addRedSocial(key: "gray", displayName: "Gris")
      self.addRedSocial(key: "green", displayName: "Verde")
      self.addRedSocial(key: "pink", displayName: "Rosa")
      self.addRedSocial(key: "purple", displayName: "Purpura")
      self.addRedSocial(key: "red", displayName: "Rojo")
    }
   
   
 
   
   func addRedSocial(key: String, displayName: String) {
      
      let optionalGenericMap : [String: Any]? = self.redesMap! [key] as? [String: Any]
      
      if let genericMap = optionalGenericMap {
         let genericTag : String = genericMap ["name"] as? String ?? ""
         let genericLink : String = genericMap ["link"] as? String ?? ""
         let genericAmount : String = genericMap ["amount"] as? String ?? ""
         let genericImage : String = genericMap ["image_url"] as? String ?? ""
         let genericItem : Gifts = Gifts (identifier: key, tag: genericTag , link: genericLink, imageUrl: genericImage, cantidad: genericAmount, title:displayName)
         self.items.append(genericItem)
      }

   }
   
    @IBAction func saveAction(_ sender: Any) {
      self.saveRedSocial(key: "blue", displayName: "Azul")
      self.saveRedSocial(key: "gray", displayName: "Gris")
      self.saveRedSocial(key: "green", displayName: "Verde")
      self.saveRedSocial(key: "pink", displayName: "Rosa")
      self.saveRedSocial(key: "purple", displayName: "Purpura")
      self.saveRedSocial(key: "red", displayName: "Rojo")
      self.displaySuccess()
   }
   
   func saveRedSocial(key: String, displayName: String) {
      let textfieldFacebookTag = (self.dataDictionary ["\(displayName)-tag"] as? UITextField)?.text
      let textfieldFacebookAmount = (self.dataDictionary ["\(displayName)-amount"] as? UITextField)?.text
      let textfieldFacebookLink = (self.dataDictionary ["\(displayName)-link"] as? UITextField)?.text
      var facebookMap : [String: String] = [:]
      facebookMap ["name"] = textfieldFacebookTag
      facebookMap ["link"] = textfieldFacebookLink
      facebookMap ["amount"] = textfieldFacebookAmount
      self.ref.child("Eventos").child(self.pageName).child("gifts").child(key).setValue(facebookMap)
   }
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.items.count
   }
    
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "giftCell") as! GiftTableViewCell
      let row = indexPath.row
      let currentItem = self.items [row]
      
      
      cell.titleLabel.text = currentItem.title
      cell.tagTextfield.text = currentItem.tag
      cell.linkTextfield.text = currentItem.link
      cell.key = currentItem.identifier
      cell.amountTextField.text = currentItem.cantidad
      cell.amountTextField.keyboardType = .phonePad
      cell.imageTextField.text = currentItem.imageUrl
      
      self.dataDictionary ["\(currentItem.title)-tag"] = cell.tagTextfield
      self.dataDictionary ["\(currentItem.title)-link"] = cell.linkTextfield
      self.dataDictionary ["\(currentItem.title)-amount"] = cell.amountTextField

      
      return cell
      
   }
   

@IBAction func newSocialNetwork(_ sender: Any) {
      
      let alert = UIAlertController(title: "Regalos", message: "Elige alguna regalo que desees asociar a tu evento", preferredStyle: UIAlertControllerStyle.alert)
      //agrego acciones a la alerta
      alert.addAction(UIAlertAction(title: "Azul", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "blue"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Gris", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "gray"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Verde", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "green"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Rosa", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "pink"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Purpura", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "purple"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Rojo", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "red"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler:nil))
      self.present(alert, animated: true, completion: nil)
   }
   
   
   func proposeNewDisplayName() {
      
      let alertController = UIAlertController(title: "¿Qué nombre deseas mostrar?", message: "Ingresa un texto que identifique el regalo", preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         let firstTextField = alertController.textFields![0] as UITextField?
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar algún texto")
            return
         }
         self.chooseLink((firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Texto del item de regalo"
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
   
   func chooseLink (_ displayName : String){
      
      let alertController = UIAlertController(title: "¿Cual es el link al que debe llevar este item?", message: "Este link permite abrir la página del metodo de pago para el regalo", preferredStyle: .alert)
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Dirección URL"
      }

      let firstTextField = alertController.textFields![0] as UITextField?
      firstTextField?.text = "http://"
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar la dirección URL a utilizar")
            return
         }
         
         self.choosePrice(displayName, link: (firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
      
   }
   
   func choosePrice (_ displayName: String,link : String){
      
      let alertController = UIAlertController(title: "¿Cual es el precio del regalo?", message: "Informacion del dinero a gastar", preferredStyle: .alert)
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Precio del regalo"
      }
      let firstTextField = alertController.textFields![0] as UITextField?
      firstTextField?.text = "$ "
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar un precio valido")
            return
         }
         
         self.createNewRedSocial(displayName: displayName, link: link, cantidad:  (firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
      
   }
   
   
   

   func createNewRedSocial(displayName: String,  link: String, cantidad: String)
   {
      if (displayName.isEmpty || link.isEmpty) {
         self.displayError(message:"El campo de ingreso esta vacio");
         return
      }
   
      var facebookMap : [String: String] = [:]
      facebookMap ["name"] = displayName
      facebookMap ["link"] = link
      facebookMap ["amount"] = cantidad
   self.ref.child("Eventos").child(self.pageName).child("gifts").child(self.currentSocialKey).setValue(facebookMap)
      self.displaySuccess()
   }
   
    @IBAction func deleteCurrentSocialNetwork(_ sender: Any) {
      let button = sender as! UIButton
      let cell = button.superview?.superview as! GiftTableViewCell
      self.ref.child("Eventos").child(self.pageName).child("gifts").child(cell.key).removeValue()
      self.displaySuccess()
    }
    
   func displayError (message: String = "No pudimos realizar esta acción, intenta mas tarde.") {
      PKHUD.sharedHUD.hide()
      let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
   }
   
   func displaySuccess () {
      PKHUD.sharedHUD.hide()
      let alert = UIAlertController(title: "Cambio aceptado", message: "Has realizado con éxito esta acción. Vuelve a acceder al evento si deseas realizar más cambios.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: {(action) in
         self.navigationController?.popToRootViewController(animated: true)
      }))
      self.present(alert, animated: true, completion: nil)
   }
}


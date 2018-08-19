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

class RedSocialViewController: UIViewController, UITableViewDataSource {
   
   public var information : [AnyHashable: Any] = [:]
   public var pageName : String = ""
   var items : [Redsocial] = []
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
      
      self.redesMap = self.information ["redes"] as? [String: Any] ?? [:]
      self.addRedSocial(key: "facebook", displayName: "Facebook")
      self.addRedSocial(key: "instagram", displayName: "Instagram")
      self.addRedSocial(key: "twitter", displayName: "Twitter")
      self.addRedSocial(key: "snapchat", displayName: "Snapchat")
      self.addRedSocial(key: "youtube", displayName: "Youtube")
      self.addRedSocial(key: "webpage", displayName: "Pagina Web")
    }
   
   
 
   
   func addRedSocial(key: String, displayName: String) {
      
      let optionalGenericMap : [String: Any]? = self.redesMap! [key] as? [String: Any]
      
      if let genericMap = optionalGenericMap {
         let genericTag : String = genericMap ["name"] as? String ?? ""
         let genericLink : String = genericMap ["link"] as? String ?? ""
         let genericItem : Redsocial = Redsocial (title:displayName, tag: genericTag , link: genericLink, key: key)
         self.items.append(genericItem)
      }

   }
   
    @IBAction func saveAction(_ sender: Any) {
      self.saveRedSocial(key: "facebook", displayName: "Facebook")
      self.saveRedSocial(key: "instagram", displayName: "Instagram")
      self.saveRedSocial(key: "twitter", displayName: "Twitter")
      self.saveRedSocial(key: "snapchat", displayName: "Snapchat")
      self.saveRedSocial(key: "youtube", displayName: "Youtube")
      self.saveRedSocial(key: "webpage", displayName: "Pagina Web")
      self.displaySuccess()
   }
   
   func saveRedSocial(key: String, displayName: String) {
      let textfieldFacebookTag = (self.dataDictionary ["\(displayName)-tag"] as? UITextField)?.text
      let textfieldFacebookApplink = (self.dataDictionary ["\(displayName)-applink"] as? UITextField)?.text
      let textfieldFacebookLink = (self.dataDictionary ["\(displayName)-link"] as? UITextField)?.text
      var facebookMap : [String: String] = [:]
      facebookMap ["name"] = textfieldFacebookTag
      facebookMap ["link"] = textfieldFacebookLink
      facebookMap ["applink"] = textfieldFacebookApplink
      self.ref.child("Eventos").child(self.pageName).child("redes").child(key).setValue(facebookMap)
   }
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.items.count
   }
    
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "socialCell") as! RedSocialTableViewCell
      let row = indexPath.row
      let currentItem = self.items [row]
      
      cell.titleLabel.text = currentItem.title
      cell.tagTextfield.text = currentItem.tag
      cell.linkTextfield.text = currentItem.link
      cell.key = currentItem.key
      
      self.dataDictionary ["\(currentItem.title)-tag"] = cell.tagTextfield
      self.dataDictionary ["\(currentItem.title)-link"] = cell.linkTextfield
      
      return cell
      
   }
   

@IBAction func newSocialNetwork(_ sender: Any) {
      
      let alert = UIAlertController(title: "Redes sociales", message: "Elige alguna red social que desees asociar a tu evento", preferredStyle: UIAlertControllerStyle.alert)
      //agrego acciones a la alerta
      alert.addAction(UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "facebook"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Instagram", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "instagram"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "twitter"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Snapchat", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "snapchat"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Youtube", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "youtube"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Pagina web", style: UIAlertActionStyle.default, handler: {(action) in
         self.currentSocialKey = "webpage"
         self.proposeNewDisplayName()
      }))
      alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler:nil))
      self.present(alert, animated: true, completion: nil)
   }
   
   
   func proposeNewDisplayName() {
      
      let alertController = UIAlertController(title: "¿Qué nombre deseas mostrar?", message: "Ingresa un texto que identifique la pagina con esta red social", preferredStyle: .alert)
      
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
         textField.placeholder = "Texto del item de red social"
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
   
   func chooseLink (_ displayName : String){
      
      let alertController = UIAlertController(title: "¿Cual es el link al que debe llevar este item?", message: "Este link permite abrir la página en el contexto del navegador o de la app correspondiente", preferredStyle: .alert)
      
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
         
         self.createNewRedSocial(displayName: displayName, link: (firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
      
   }
   

   func createNewRedSocial(displayName: String,  link: String)
   {
      if (displayName.isEmpty || link.isEmpty) {
         self.displayError(message:"El campo de ingreso esta vacio");
         return
      }
   
      var facebookMap : [String: String] = [:]
      facebookMap ["name"] = displayName
      facebookMap ["link"] = link
      self.ref.child("Eventos").child(self.pageName).child("redes").child(self.currentSocialKey).setValue(facebookMap)
      self.displaySuccess()
   }
   
    @IBAction func deleteCurrentSocialNetwork(_ sender: Any) {
      let button = sender as! UIButton
      let cell = button.superview?.superview as! RedSocialTableViewCell
      self.ref.child("Eventos").child(self.pageName).child("redes").child(cell.key).removeValue()
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


//
//  AssignmentViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD


class AssignmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var filterTablesButton: UIButton!
    @IBOutlet weak var filterAbcButton: UIButton!
    
    @IBOutlet weak var filterAssistanceButton: UIButton!
   

   var permissionsData : [String : [String]]?
   var accessType : String?
   let kRed = UIColor(red: 206.0/255.0, green: 46.0/255.0, blue: 35.0/255.0, alpha: 1.0)
   let kGreen = UIColor(red: 3.0/255.0, green: 178.0/255.0, blue: 32.0/255.0, alpha: 1.0)
   let kOrange = UIColor(red: 242.0/255.0, green: 117.0/255.0, blue: 0.0/255.0, alpha: 1.0)
   
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var assignmentTable: UITableView!
   
   var allInvitesKeys : [String] = [];
   var allInvites : [AnyHashable:Any] = [:];
   var allTableAssignments : [AnyHashable:Any] = [:];
   var allUserAssignments : [AnyHashable:Any] = [:];
   var currentMesaInvites : [[AnyHashable:Any]] = [];
   
   var myFriends : [[AnyHashable:Any]] = [];
   var myTableName : String = "";
   var state : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      self.getPermissionsDataAndContinue()
      self.filterAbcButton.backgroundColor = .clear
      self.filterAbcButton.layer.cornerRadius = 13
      self.filterAbcButton.layer.borderWidth = 1
      self.filterAbcButton.layer.borderColor = UIColor.white.cgColor
      self.filterTablesButton.backgroundColor = .clear
      self.filterTablesButton.layer.cornerRadius = 13
      self.filterTablesButton.layer.borderWidth = 1
      self.filterTablesButton.layer.borderColor = UIColor.white.cgColor
      
      self.filterAssistanceButton.backgroundColor = .clear
      self.filterAssistanceButton.layer.cornerRadius = 13
      self.filterAssistanceButton.layer.borderWidth = 1
      self.filterAssistanceButton.layer.borderColor = UIColor.white.cgColor

      self.assignmentLabel.backgroundColor = UIColor.black
      
      PKHUD.sharedHUD.contentView = PKHUDProgressView()
      PKHUD.sharedHUD.show()
      self.assignmentTable.dataSource = self;
      self.assignmentTable.delegate = self;
      self.assignmentTable.alpha = 0
      self.descriptionLabel.alpha = 0
      getCurrentEventInvites()
      selectAbcButton(nil)
    }
    
   @IBAction func showNewEvent(_ sender: Any) {
      
   
   }
   @IBAction func selectTableButton(_ sender: Any?) {
      self.setupButton(key: "mesa")
      state = 0
      self.allInvitesKeys = self.allInvitesKeys.sorted {
         let string1 = self.allTableAssignments [$0] as! String? ?? "Nada"
         let string2 = self.allTableAssignments [$1] as! String? ?? "Nada"
         
         
         
         if (string1 == "Nada") {
            return true
         }
         if (string2 == "Nada") {
            return false
         }
         return  string1 < string2
      }
      self.assignmentTable.reloadData()

   }
   @IBAction func selectAbcButton(_ sender: Any?) {
      self.setupButton(key: "abecedario")
      state = 1
      self.allInvitesKeys = self.allInvitesKeys.sorted {
         let item1 = self.allUserAssignments [$0] as! [AnyHashable : Any]
         let item2 = self.allUserAssignments [$1] as! [AnyHashable : Any]
         var string1 = item1 ["apellido"] as! String
         var string2 = item2 ["apellido"] as! String
         string1 = string1.capitalized
         string2 = string2.capitalized
         return  string1 < string2
      }
      self.assignmentTable.reloadData()
   }
   
   @IBAction func selectAssistanceButton(_ sender: Any?) {
      self.setupButton(key: "asistencia")
      state = 2
      self.allInvitesKeys = self.allInvitesKeys.sorted {
         let status1 = self.allInvites [$0] as! String
         let status2 = self.allInvites [$1] as! String
         let int1 = self.statusquo(status: status1)
         let int2 = self.statusquo(status: status2)
         
         
         
         return  int1 < int2
      }
    

      self.assignmentTable.reloadData()
   }
   
   func statusquo (status:String)-> Int{
      
      switch (status){
         
         case "confirmado" : return 1
         case "cancelado" : return 4
         case "indeterminado" : return 3
         case "quizas" : return 2
         
         
         default: return 100
      }
   }
   
   func getPermissionsDataAndContinue () {
      ref.child("Accesos").observeSingleEvent(of: .value, with: { (snapshot) in
         // Get user value
         let data = snapshot.value as? NSDictionary!
         if let unwData = data {
            self.permissionsData = unwData as? [String : [String]];
            self.accessType = nil
            
            self.checkCurrentPermission(key: "Admin")
            self.checkCurrentPermission(key: "Cliente")
            self.checkCurrentPermission(key: "Recepcion")
            
            PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
            }
            
         } else {
            self.displayError()
         }
      }) { (error) in
         self.displayError()
      }
   }
   
   func checkCurrentPermission(key: String) {
      let myEmail = Auth.auth().currentUser?.email;
      let emails = self.permissionsData![key]
      for currentEmail in emails! {
         if (currentEmail == myEmail) {
            self.accessType = key
         }
      }
      
   }
   func getUserDataAndContinue () {
        let userEmail = Auth.auth().currentUser?.email;
        
        if (userEmail == nil) {
            self.displayError()
            return;
        }
        
        ref.child("Asignaciones").child(pageName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.myFriends = [];
            let userAssignmentData = snapshot.value as? [AnyHashable : Any] ?? [:]
            for key in userAssignmentData.keys {
                let allAssignments : [[AnyHashable:Any]] = userAssignmentData [key] as! [[AnyHashable:Any]]
                self.myFriends.append(contentsOf: allAssignments)
               for assignmentMap in allAssignments {
                  for nickname in self.allInvitesKeys {
                     if ((assignmentMap ["nickname"]  as! String) == nickname) {
                        self.allTableAssignments [nickname] = key
                     }
                  }
               }
               
            }
            self.getAllUsers()
        }) { (error) in
            self.displayError()
        }
    }
   
   func getAllUsers () {
      ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in

                     var newAllInvites : [String] = []
         let userAssignmentData = snapshot.value as? [AnyHashable : Any] ?? [:]
         for userKey in userAssignmentData.keys {
            let userMap = userAssignmentData [userKey] as! [AnyHashable: Any]
            for nickname in self.allInvitesKeys {
               if ((userMap ["nickname"]  as! String) == nickname) {
                  self.allUserAssignments [nickname] = userMap
                  
                  newAllInvites.append (nickname)
               }
            }
         }
         self.allInvitesKeys =  Array(Set(newAllInvites))
         self.allInvitesKeys = self.allInvitesKeys.sorted {
            let item1 = self.allUserAssignments [$0] as! [AnyHashable : Any]
            let item2 = self.allUserAssignments [$1] as! [AnyHashable : Any]
            var string1 = item1 ["apellido"] as! String
            var string2 = item2 ["apellido"] as! String
            string1 = string1.capitalized
            string2 = string2.capitalized
             return  string1 < string2
            
         }
         self.showInformation()
         switch(self.state) {
         case 0:
            self.selectTableButton(0)
            break;
            
         case 1:
            self.selectAbcButton(0)
            break;
            
         case 2:
            self.selectAssistanceButton(0)
            break;
         default:
            break;
         }
      }) { (error) in
         self.displayError()
      }
   }
   
   func showInformation () {
      
      self.assignmentLabel.text = "Invitados"
      self.descriptionLabel.text = "Estos son todos los invitados que accedieron al evento"
      self.assignmentTable.reloadData()
      UIView.animate(withDuration: 0.3, animations: {
         self.assignmentTable.alpha = 1
         self.descriptionLabel.alpha = 1
      })
      PKHUD.sharedHUD.hide()
   }
   
   
   
   func getCurrentEventInvites ()
   {
         ref.child("Eventos").child(pageName).child("invitados").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userEventData = snapshot.value as? [AnyHashable : Any]
            if let userEventData = userEventData {
               self.allInvites = userEventData;
               self.allInvitesKeys = Array(self.allInvites.keys) as! [String]
               self.getUserDataAndContinue()
            } else {
               self.displayError(message: "No hay nadie que haya aceptado esta invitación aun")
            }
         }) { (error) in
            self.displayError()
         }

   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allInvitesKeys.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let inviteKey = self.allInvitesKeys [indexPath.row]
        let status = self.allInvites [inviteKey] as! String
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! AssignmentTableViewCell
      cell.userStatusLabel.text = "Estado: " + status.capitalized
      cell.assignmentLabel.text = "Asignado a: " +  (self.allTableAssignments [inviteKey] as! String? ?? "Nada")
      let userMap = self.allUserAssignments [inviteKey] as! [AnyHashable:Any]? ?? [:]
      let name = userMap ["nombre"] as! String? ?? ""
      let apellidoRaw = userMap ["apellido"] as! String?
      let apellido = apellidoRaw != nil ? ("\(apellidoRaw!), ") : ""
      let telefono = userMap ["telefono"] as! String? ?? ""
      let email = userMap ["email"] as! String? ?? ""
      let fullname =  "\(apellido.capitalized)\(name.capitalized)"
      let fullUserDescription = "Telefono: \(telefono)\nMail: \(email)"
      cell.friendLabel.text = fullname
      cell.userDescriptionLabel.text = fullUserDescription
      cell.tag = indexPath.row
      
      guard let variableDeAccesoNoOpcional = self.accessType else {
         let alert = UIAlertController(title: "Error", message: "No tienes permisos para acceder a esta seccion", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return cell
      }
      
      switch (variableDeAccesoNoOpcional) {
      case "Admin":  cell.assignButton.isHidden = false
         break
      case "Cliente":  cell.assignButton.isHidden = true
         break
      case "Recepcion":  cell.assignButton.isHidden = true
         break
         
      default: let alert = UIAlertController(title: "Error", message: "No tienes permisos para acceder a esta seccion", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
         break
      }
      
      if (status == "indeterminado") {
         cell.statusSquare.backgroundColor = UIColor.darkGray
      } else if (status == "confirmado") {
         cell.statusSquare.backgroundColor = kGreen
      } else if (status == "quizas") {
         cell.statusSquare.backgroundColor = kOrange
      } else if (status == "cancelado") {
         cell.statusSquare.backgroundColor = kRed
      } else {
         cell.statusSquare.backgroundColor = UIColor.black
      }
      
        return cell
    }
    
    func displayError (message: String = "No pudimos cambiar tu estado de confirmacion, intenta mas tarde.") {
        PKHUD.sharedHUD.hide()
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 180
   }
    
    @IBAction func statusButtonPressed(_ sender: Any) {
    }
    
    @IBAction func assignButtonPressed(_ sender: Any) {
      
      let button = sender as! UIButton
      let inviteKey = self.allInvitesKeys [button.tag]
      let userMap = self.allUserAssignments [inviteKey] as! [AnyHashable:Any]? ?? [:]
      sendMap(userMap)
    }
   
   func sendMap (_ userMap : [AnyHashable:Any])
   {
      let alertController = UIAlertController(title: "¿Qué mesa quieres asignarle?", message: "", preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         let firstTextField = alertController.textFields![0] as UITextField?
         let mesaNumber = (firstTextField?.text)!
         self.sendAssignment(mesa: "Mesa \(mesaNumber)", userMap: userMap)

         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Número de la mesa"
         textField.keyboardType = UIKeyboardType.numberPad
      }
      
      alertController.addAction(saveAction)
      alertController.addAction(cancelAction)
      
      self.present(alertController, animated: true, completion: nil)

   }
   
   func sendAssignment (mesa : String, userMap : [AnyHashable:Any])
   {
      if (mesa.isEmpty) {
         self.displayError(message:"El campo de ingreso esta vacio");
         return
      }
      
      let nickname = userMap ["nickname"] as! String? ?? ""
      
      if let currentMesa = self.allTableAssignments [nickname] as! String? {
         ref.child("Asignaciones").child(pageName).child(currentMesa).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.currentMesaInvites = snapshot.value as? [[AnyHashable:Any]] ?? []
            self.currentMesaInvites = self.currentMesaInvites.filter { $0 ["nickname"] as! String != nickname}
            self.ref.child("Asignaciones").child(self.pageName).child(currentMesa).setValue(self.currentMesaInvites)
         }) { (error) in
            self.displayError()
         }
         
      }
      
      
      ref.child("Asignaciones").child(pageName).child(mesa).observeSingleEvent(of: .value, with: { (snapshot) in
         // Get user value
         self.currentMesaInvites = snapshot.value as? [[AnyHashable:Any]] ?? []
         let name = userMap ["nombre"] as! String? ?? ""
         let apellidoRaw = userMap ["apellido"] as! String?
         let apellido = apellidoRaw != nil ? ("\(apellidoRaw!), ") : ""
         let email = userMap ["email"] as! String? ?? ""
         let fullname =  "\(apellido)\(name)"
         let map = ["nombre":fullname,"nickname":nickname,"mail":email] as [AnyHashable : Any]
         
         
         self.currentMesaInvites = self.currentMesaInvites.filter { $0 ["nickname"] as! String != nickname}
         self.currentMesaInvites.append(map)
         self.ref.child("Asignaciones").child(self.pageName).child(mesa).setValue(self.currentMesaInvites)
         let alert = UIAlertController(title: "¡Asignacion actualizada!", message: "Has cargado a \(name) con la asignación \(mesa)", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         PKHUD.sharedHUD.show()
         self.getCurrentEventInvites()
         
      }) { (error) in
         self.displayError()
      }
      
   }
   func setupButton (key : String)
   {
      if (key == "asistencia") {
         
         self.filterAssistanceButton.backgroundColor = kGreen
         self.filterTablesButton.backgroundColor = UIColor.clear
         self.filterAbcButton.backgroundColor = UIColor.clear
         
         UIView.animate(withDuration: 0.3, animations: {
            self.filterAssistanceButton.alpha = 1
            self.filterTablesButton.alpha = 1
            self.filterAbcButton.alpha = 1
         })
      }
      
      if (key == "mesa") {
         
         
         self.filterTablesButton.backgroundColor = kGreen
         self.filterAssistanceButton.backgroundColor = UIColor.clear
         self.filterAbcButton.backgroundColor = UIColor.clear
         UIView.animate(withDuration: 0.3, animations: {
            self.filterAssistanceButton.alpha = 1
            self.filterTablesButton.alpha = 1
            self.filterAbcButton.alpha = 1
         })
      }
      
      if (key == "abecedario") {
         self.filterAbcButton.backgroundColor = kGreen
         self.filterAssistanceButton.backgroundColor = UIColor.clear
         self.filterTablesButton.backgroundColor = UIColor.clear
         UIView.animate(withDuration: 0.3, animations: {
            self.filterAssistanceButton.alpha = 1
            self.filterTablesButton.alpha = 1
            self.filterAbcButton.alpha = 1
         })
      }
   }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "social" {
            let viewController: SocialViewController = segue.destination as! SocialViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
        
        if segue.identifier == "songs" {
            let viewController: SongsViewController = segue.destination as! SongsViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
         
   
    }
    
}

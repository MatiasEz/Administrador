//
//  LoginViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//
import FirebaseAuth
import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var ingresarButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mailBox: UITextField!
    @IBOutlet weak var passBox: UITextField!
    
    @IBOutlet weak var claveBox: UITextField!
    
   var accessType : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mailBox.keyboardType = UIKeyboardType.emailAddress
        mailBox.autocorrectionType = UITextAutocorrectionType.no
        passBox.keyboardType = UIKeyboardType.alphabet
        passBox.isSecureTextEntry = true
        claveBox.keyboardType = UIKeyboardType.alphabet
        claveBox.isSecureTextEntry = true
        
        ingresarButton.backgroundColor = .clear
        ingresarButton.layer.cornerRadius = 20
        ingresarButton.layer.borderWidth = 1
        ingresarButton.layer.borderColor = UIColor.white.cgColor
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func mailStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func mailEnded(_ sender: UITextField) {
        
    }
    @IBAction func mailAction(_ sender: Any) {
        passBox.becomeFirstResponder()
    }
    
    @IBAction func passStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func passAction(_ sender: Any) {
        claveBox.becomeFirstResponder()
    }
    
    @IBAction func claveStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func claveAction(_ sender: Any) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        claveBox.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: Any) {
        let clave = claveBox.text!;
        let email = mailBox.text!;
        let pass = passBox.text!;
      
        
        if (clave != "gamal1234") {
            displayError()
            return
        }
        
        if (email.isEmpty || pass.isEmpty) {
            displayError()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if (user == nil || error != nil) {
                self.displayError()
                return
            }
//
         
         let userId = (Auth.auth().currentUser?.uid)!;

         
         let ref = Database.database().reference()
         ref.child("Users").child(userId).child("nickname").observeSingleEvent(of: .value, with: { (snapshot) in
            let nickname = snapshot.value as? String?
            
            if (nickname == nil ) {
               self.displayError()
               return
            }
            
            UserDefaults.standard.set(nickname!, forKey: "nicknameKey")
            
            print ("mi user es: " + (user?.displayName ?? "no hay user")  + ", nickname: " + (nickname)!!)
           self.goToHomeViewController()
            self.displaySuccessfulLogin()
            
         }) { (error) in
            self.displayError()
         }
         
         
         
        }
    }
   
   func goToHomeViewController () {
      
      guard let variableDeAccesoNoOpcional = self.accessType else {
         let alert = UIAlertController(title: "Error", message: "No tienes permisos para acceder a esta seccion", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return;
      }
      
      switch (variableDeAccesoNoOpcional) {
      case "Admin":  self.performSegue(withIdentifier: "loginSuccess", sender: self)
         break
      case "Cliente":self.performSegue(withIdentifier: "loginSuccess", sender: self)
         break
      case "DJ":  self.performSegue(withIdentifier: "loginSuccess", sender: self)
         break
      case "Recepcion":  self.performSegue(withIdentifier: "loginSuccess", sender: self)
         break
         
      default:
         
         let alert = UIAlertController(title: "Error", message: "No tienes permisos para acceder a esta seccion", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         
         break
         
      }
   }
   
    func displayError () {
        let alert = UIAlertController(title: "¡Hubo un error!", message: "Revisa tu mail y contraseña y vuelve a intentarlo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displaySuccessfulLogin () {
        let alert = UIAlertController(title: "¡Ingreso exitoso!", message: "Ya puedes acceder a toda la informacion de tus eventos", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

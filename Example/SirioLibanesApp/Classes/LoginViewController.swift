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
    
    @IBOutlet weak var songSwitch: UISwitch!
    
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
      self.songSwitch.setOn(false, animated: false)
        
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
      
      UserDefaults.standard.set(self.songSwitch.isOn, forKey: "songsOnlyKey")
        
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
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
            self.displaySuccessfulLogin()
            
         }) { (error) in
            self.displayError()
         }
         
         
         
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

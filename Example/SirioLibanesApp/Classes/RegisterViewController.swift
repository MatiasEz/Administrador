//
//  RegisterViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import FirebaseAuth
import UIKit
import FirebaseDatabase

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 20
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.cgColor
        

        mailTextfield.keyboardType = UIKeyboardType.emailAddress
        mailTextfield.autocorrectionType = UITextAutocorrectionType.no
        
        nameTextfield.keyboardType = UIKeyboardType.alphabet
        nameTextfield.autocorrectionType = UITextAutocorrectionType.no
        
        passTextfield.keyboardType = UIKeyboardType.alphabet
        passTextfield.autocorrectionType = UITextAutocorrectionType.no
        passTextfield.isSecureTextEntry = true;
        
        phoneTextfield.keyboardType = UIKeyboardType.phonePad
        phoneTextfield.autocorrectionType = UITextAutocorrectionType.no
    }
    @IBAction func editBegin(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func oneEnded(_ sender: Any) {
        phoneTextfield.becomeFirstResponder()
    }
    @IBAction func twoEnded(_ sender: Any) {
        mailTextfield.becomeFirstResponder()
    }
    @IBAction func threeEnded(_ sender: Any) {
        passTextfield.becomeFirstResponder()
    }
    @IBAction func fourEnded(_ sender: Any) {
        passTextfield.resignFirstResponder()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let name = nameTextfield.text!;
        let phone = phoneTextfield.text!;
        let email = mailTextfield.text!;
        let pass = passTextfield.text!;
        
        if (email.isEmpty || pass.isEmpty || name.isEmpty || phone.isEmpty) {
            displayError()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if (user == nil || error != nil) {
                self.displayError()
                return
            }
            self.saveUserData()
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
            self.displaySuccessfulLogin()
        }
    }
    
    
    func saveUserData () {
        let name = nameTextfield.text!;
        let phone = phoneTextfield.text!;
        let email = mailTextfield.text!;
      var nickname = email.components(separatedBy: CharacterSet.alphanumerics.inverted)
         .joined()
      let diceRoll1 = Int(arc4random_uniform(9))
      let diceRoll2 = Int(arc4random_uniform(9))
      let diceRoll3 = Int(arc4random_uniform(9))
      nickname = "\(nickname)\(diceRoll1)\(diceRoll2)\(diceRoll3)"
      
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid;
        if let unwrappedUserId = userId {
         self.ref.child("Users").child(unwrappedUserId).setValue(["nombre": name,"telefono": phone,"email": email,"nickname":nickname])
         UserDefaults.standard.set(nickname, forKey: "nicknameKey")
         
        } else {
            displayError()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayError () {
        let alert = UIAlertController(title: "¡Hubo un error!", message: "Completa todos los campos y vuelve a intentarlo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displaySuccessfulLogin () {
        let alert = UIAlertController(title: "¡Ingreso exitoso!", message: "Ya puedes acceder a toda la informacion de tus eventos", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

//
//  InitialViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var ingresarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ingresarButton.backgroundColor = .clear
        ingresarButton.layer.cornerRadius = 20
        ingresarButton.layer.borderWidth = 1
        ingresarButton.layer.borderColor = UIColor.white.cgColor
      

        
        self.navigationItem.setHidesBackButton(true, animated:false);
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        if (self.navigationController?.viewControllers.count == 1) {
        self.view.window?.backgroundColor = UIColor.white
        self.navigationController?.view.alpha = 0;
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.viewControllers.count == 1) {
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "autoLogin", sender: self)
            }
            self.navigationController?.view.alpha = 1;
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

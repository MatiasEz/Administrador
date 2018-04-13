//
//  SocialViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController
{
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var instagramButton: UIButton!
    
    @IBOutlet weak var twitterButton: UIButton!
    
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        let social = information ["redes"] as! [AnyHashable: Any]
        
        let item = social ["facebook"] as! [AnyHashable: Any]
        let string = item ["name"] ?? ""
        self.facebookButton.setTitle("Facebook: \(string)", for: UIControlState.normal)
        
        let item2 = social ["instagram"] as! [AnyHashable: Any]
        let string2 = item2 ["name"] ?? ""
        self.instagramButton.setTitle("Instagram: \(string2)", for: UIControlState.normal)
        
        let item3 = social ["twitter"] as! [AnyHashable: Any]
        let string3 = item3 ["name"] ?? ""
        self.twitterButton.setTitle("Twitter: \(string3)", for: UIControlState.normal)
        
        twitterButton.layer.cornerRadius = 20
        twitterButton.layer.borderWidth = 1
        twitterButton.layer.borderColor = twitterButton.backgroundColor!.cgColor
        twitterButton.backgroundColor = .clear
        
        instagramButton.layer.cornerRadius = 20
        instagramButton.layer.borderWidth = 1
        instagramButton.layer.borderColor = instagramButton.backgroundColor!.cgColor
        instagramButton.backgroundColor = .clear
        
        facebookButton.layer.cornerRadius = 20
        facebookButton.layer.borderWidth = 1
        facebookButton.layer.borderColor = facebookButton.backgroundColor!.cgColor
        facebookButton.backgroundColor = .clear
        
        
        super.viewWillAppear(animated)
        
    }
    @IBAction func facebookPress(_ sender: Any) {
        let social = information ["redes"] as! [AnyHashable: Any]
        let item = social ["facebook"] as! [AnyHashable: Any]
        let string = (item ["link"] ?? "") as! String
        let canOpen = UIApplication.shared.canOpenURL(URL(string: string)!);
        if (canOpen) {
            UIApplication.shared.openURL(URL(string: string)!)
        } else {
            displayError()
        }
    }
    
    @IBAction func instagramPress(_ sender: Any) {
        let social = information ["redes"] as! [AnyHashable: Any]
        let item = social ["instagram"] as! [AnyHashable: Any]
        let string = (item ["link"] ?? "") as! String
        let canOpen = UIApplication.shared.canOpenURL(URL(string: string)!);
        if (canOpen) {
            UIApplication.shared.openURL(URL(string: string)!)
        } else {
            displayError()
        }
    }
    
    
    @IBAction func twitterPress(_ sender: Any) {
        let social = information ["redes"] as! [AnyHashable: Any]
        let item = social ["twitter"] as! [AnyHashable: Any]
        let string = (item ["link"] ?? "") as! String
        let canOpen = UIApplication.shared.canOpenURL(URL(string: string)!);
        if (canOpen) {
            UIApplication.shared.openURL(URL(string: string)!)
        } else {
            displayError()
        }
    }
    
    func displayError (message: String = "No acceder a este link, intenta buscando desde el navegador.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//
//  MenuViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 16/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OptionsViewController: UIViewController
{
   @IBOutlet weak var twoButton: UIButton!
   @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    public var information : [AnyHashable: Any] = [:]
   public var pageName : String = ""
   var ref: DatabaseReference!
   
   override func viewDidLoad() {
      ref = Database.database().reference()
    
    fourthButton.backgroundColor = .clear
    fourthButton.layer.cornerRadius = 20
    fourthButton.layer.borderWidth = 1
    fourthButton.layer.borderColor = UIColor.white.cgColor
    
    firstButton.backgroundColor = .clear
    firstButton.layer.cornerRadius = 20
    firstButton.layer.borderWidth = 1
    firstButton.layer.borderColor = UIColor.white.cgColor
    
      twoButton.backgroundColor = .clear
      twoButton.layer.cornerRadius = 20
      twoButton.layer.borderWidth = 1
      twoButton.layer.borderColor = UIColor.white.cgColor
      
      threeButton.backgroundColor = .clear
      threeButton.layer.cornerRadius = 20
      threeButton.layer.borderWidth = 1
      threeButton.layer.borderColor = UIColor.white.cgColor
      
      
      super.viewDidLoad()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "social" {
         let viewController: SocialViewController = segue.destination as! SocialViewController
         viewController.information = self.information
         viewController.pageName = self.pageName
      }
      
      if segue.identifier == "today" {
         let viewController: AssignmentViewController = segue.destination as! AssignmentViewController
         viewController.information = self.information
         viewController.pageName = self.pageName
      }
      
      if segue.identifier == "songs" {
         let viewController: SongsViewController = segue.destination as! SongsViewController
         viewController.information = self.information
         viewController.pageName = self.pageName
      }
      
      if segue.identifier == "detailEvent" {
         let viewController: DetailViewController = segue.destination as! DetailViewController
         viewController.information = self.information
         viewController.pageName = self.pageName
      }
   }
   
}


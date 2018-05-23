//
//  HomeViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyState: UIView!
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var ref: DatabaseReference!
    var userItemList : [String] = []
    var allEvents : [AnyHashable : Any] = [:]
    var userEvents : [AnyHashable : Any] = [:]
    var firstTime : Bool = true
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated:false);

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emptyState.alpha = 0;
        self.tableView.alpha = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (backViewController() is RegisterViewController && firstTime) {
            updateViewWithCurrentInformation()
            firstTime = false;
            return
        }
        
        self.tableView.backgroundColor = UIColor.clear
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        getEventsDataAndContinue()
    }
    
    func backViewController () -> UIViewController?
    {
        let numberOfViewControllers = self.navigationController?.viewControllers.count ?? 0;
        if (numberOfViewControllers < 2) {
            return nil;
        } else {
            return self.navigationController?.viewControllers [numberOfViewControllers - 2];
        }
    }
   
   public func createPlaceholderEvent(map : [AnyHashable:Any]) {
      
      self.ref.child("Eventos").child(map["key"] as! String).setValue(map)
      self.ref.child("Codigos").child(map["qrkey"] as! String).setValue(map["key"] as! String)
      
      PKHUD.sharedHUD.contentView = PKHUDProgressView()
      PKHUD.sharedHUD.show()
      getEventsDataAndContinue()
      
   }
    
    func getEventsDataAndContinue () {
        ref.child("Eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventData = snapshot.value as? NSDictionary!
            if let unwEventData = eventData {
                self.allEvents = unwEventData as! [AnyHashable : Any];
               self.userEvents = self.allEvents;
               self.userItemList = Array(self.userEvents.keys) as! [String]
               self.updateViewWithCurrentInformation()
            } else {
                self.displayError()
            }
        }) { (error) in
            self.displayError()
        }
    }
    
    func updateViewWithCurrentInformation () {
        
        self.tableView.alpha = 0;
        self.emptyState.alpha = 0;

        let visibleView = (self.userItemList.count > 0) ? self.tableView as UIView : self.emptyState as UIView
        UIView.animate(withDuration: 0.3, animations: {
            visibleView.alpha = 1
        })
        if (self.userItemList.count > 0) {
            self.tableView.reloadData()
        }
        
        PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userEvents.keys.count;
    }
        
    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        let key = self.userItemList [button.tag]
        let map = self.userEvents [key] as! [AnyHashable : Any]
        self.information = map
        self.pageName = key
        self.performSegue(withIdentifier: "social", sender: self)
    }
    
    @IBAction func todayButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        let key = self.userItemList [button.tag]
        let map = self.userEvents [key] as! [AnyHashable : Any]
        self.information = map
        self.pageName = key
        self.performSegue(withIdentifier: "today", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = self.userItemList [indexPath.row]
        let map = self.userEvents [key] as! [AnyHashable : Any]
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        cell.tag = indexPath.row
        cell.asociatedDictionary = map
        cell.titlecustomLabel.text = map ["titulo"] as! String?
        cell.descriptioncustomLabel.text = "La clave de este evento es: \"\(key)\""
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = self.userItemList [indexPath.row]
        let map = self.userEvents [key] as! [AnyHashable : Any]
        self.information = map
        self.pageName = key
        self.goToDetailScreen()
    }
    
    func goToDetailScreen ()
    {
      
      let songsOnly = UserDefaults.standard.bool(forKey: "songsOnlyKey")
      if (songsOnly) {
         self.performSegue(withIdentifier: "songs", sender: self)
      } else {
        self.performSegue(withIdentifier: "detailEvent", sender: self)
      }
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Cerrar sesión", message: "¿Está seguro de que desea cerrar su sesión?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "logout", sender: self)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError (message: String = "No pudimos obtener tus eventos, intenta mas tarde.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
            // Completion Handler
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailEvent" {
            let viewController = segue.destination as! OptionsViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
        
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
    }


}

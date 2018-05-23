//
//  ViewController.swift
//  SirioLibanesApp
//
//  Created by federico0812 on 02/04/2018.
//  Copyright (c) 2018 federico0812. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RedSocialViewController: UIViewController, UITableViewDataSource {
   
   public var information : [AnyHashable: Any] = [:]
   public var pageName : String = ""
   var items : [Redsocial] = []
   var ref: DatabaseReference!
   var dataDictionary : [String:Any] = [:]
   var redesMap : [String: Any]?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editingDidBegin(_ sender: Any) {
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 216, right: 0)

    }
    override func viewDidLoad() {
      ref = Database.database().reference()
      super.viewDidLoad()
      

      self.tableView.dataSource = self;
      
      self.redesMap = self.information ["redes"] as? [String: Any] ?? [:]
      self.addRedSocial(key: "facebook", displayName: "Facebook")
      self.addRedSocial(key: "instagram", displayName: "Instagram")
      self.addRedSocial(key: "twitter", displayName: "Twitter")
      self.addRedSocial(key: "snapchat", displayName: "Snapchat")
      self.addRedSocial(key: "youtube", displayName: "Youtube")
      self.addRedSocial(key: "webPage", displayName: "Pagina Web")
    }
   
   func addRedSocial(key: String, displayName: String) {
      
      let optionalGenericMap : [String: Any]? = self.redesMap! [key] as? [String: Any]
      
      if let genericMap = optionalGenericMap {
         let genericTag : String = genericMap ["name"] as? String ?? ""
         let genericLink : String = genericMap ["link"] as? String ?? ""
         let genericApplink : String? = genericMap ["applink"] as? String
         let genericItem : Redsocial = Redsocial (title:displayName, tag: genericTag , link: genericLink, applink: genericApplink)
         self.items.append(genericItem)
      }

   }
   
    @IBAction func saveAction(_ sender: Any) {
      self.saveRedSocial(key: "facebook", displayName: "Facebook")
      self.saveRedSocial(key: "instagram", displayName: "Instagram")
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
      cell.applinkTextfield.text = currentItem.applink
      cell.linkTextfield.text = currentItem.link
      
      self.dataDictionary ["\(currentItem.title)-tag"] = cell.tagTextfield
      self.dataDictionary ["\(currentItem.title)-applink"] = cell.applinkTextfield
      self.dataDictionary ["\(currentItem.title)-link"] = cell.linkTextfield
      
      return cell
      
   }
}


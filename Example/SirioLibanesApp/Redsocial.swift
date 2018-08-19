//
//  Redsocial.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 20/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Redsocial: NSObject {
   
   
   var title : String
   var tag : String
   var link : String
   var key : String
   
   public init(title: String, tag: String, link: String, key: String) {
      self.title = title
      self.tag = tag
      self.link = link
      self.key = key
   }
}

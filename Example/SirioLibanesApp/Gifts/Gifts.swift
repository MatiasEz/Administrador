//
//  Redsocial.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 20/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Gifts: NSObject {
   
   
   var identifier : String
   var tag : String
   var link : String
   var imageUrl : String
   var cantidad : String
   var title : String
   
   public init(identifier: String, tag: String, link: String, imageUrl: String, cantidad: String, title: String) {
      self.identifier = identifier
      self.tag = tag
      self.link = link
      self.imageUrl = imageUrl
      self.cantidad = cantidad
      self.title = title

   }
}

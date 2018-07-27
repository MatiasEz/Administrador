//
//  Invitado.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 27/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Invitado: NSObject {
   
   var cantidad : Int
   var mesa : Int
   var mail : String? = nil
   var ingresado : Bool
   var fullname : String
   
   
   public init(mail: String? = nil, mesa: Int, ingresado: Bool,fullname: String, cantidad: Int ) {
      self.mail = mail
      self.mesa = mesa
      self.ingresado = ingresado
      self.fullname = fullname
      self.cantidad = cantidad
   }
   public init(map:[String:Any] ) {
      self.mail = map["mail"] as! String?
      self.mesa = map["mesa"] as! Int
      self.ingresado = map["ingresado"] as! Bool
      self.fullname = map["fullname"] as! String
      self.cantidad = map["cantidad"] as! Int
   }

}

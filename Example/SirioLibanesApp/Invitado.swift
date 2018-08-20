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
   var position : Int?
   
   
   public init(mail: String? = nil, mesa: Int, ingresado: Bool,fullname: String, cantidad: Int ) {
      self.mail = mail
      self.mesa = mesa
      self.ingresado = ingresado
      self.fullname = fullname
      self.cantidad = cantidad
   }
   public init(map:[String:Any] ) {
      let mail = map["mail"] as? String
      self.mail = mail?.lowercased()
      let mesaInt = map["mesa"] as? Int
      let mesaString = map["mesa"] as? String
      self.mesa = mesaInt ?? Int(mesaString ?? "0") ?? 0
      self.ingresado = map["ingresado"] as? Bool ?? false
      self.fullname = map["fullname"] as? String ?? "No name"
      
      let cantInt = map["cantidad"] as? Int
      let cantString = map["cantidad"] as? String
      self.cantidad = cantInt ?? Int(cantString ?? "1") ?? 1
   }

}

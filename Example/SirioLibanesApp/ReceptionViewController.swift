//
//  ReceptionViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 25/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseDatabase
import PKHUD

class ReceptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
   var ref: DatabaseReference!
   var mapInvitados : [Invitado] = []

    override func viewDidLoad() {
      PKHUD.sharedHUD.contentView = PKHUDProgressView()
      PKHUD.sharedHUD.show()
      ref = Database.database().reference()
      self.tableView.delegate = self;
      self.tableView.dataSource = self;
      self.getUserInfo()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.mapInvitados.count;
      
   }
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "receptionCell") as! ReceptionTableViewCell
      let position = indexPath.row
      let currentInvitado = mapInvitados[position]
      cell.nameLabel.text = currentInvitado.fullname
      
      let variableIntCantidad = currentInvitado.cantidad
      let stringCantidad = "\(variableIntCantidad)"
      cell.quantityLabel.text = stringCantidad
      
      let variableIntMesa = currentInvitado.mesa
      let stringMesa = "\(variableIntMesa)"
      cell.tableNumberLabel.text = stringMesa
      
    if (currentInvitado.mail == nil) {
        
        cell.qrImage.isHidden = true
    } else {
        
        cell.qrImage.isHidden = false

    }
    
    
      
      if (currentInvitado.ingresado == true) {
         cell.presenceButton.setImage(UIImage(named: "ingresado"), for: .normal)
      } else {
         cell.presenceButton.setImage(UIImage(named: "noingresado"), for: .normal)
      }
      
      
      
      return cell

      
      
   }
   
    @IBAction func refreshDataAction(_ sender: Any) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){ self.tableView.reloadData()}
    }
    
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
      PKHUD.sharedHUD.show()
      let position = indexPath.row
      let currentInvitado = self.mapInvitados [position] as! Invitado
      if  (currentInvitado.ingresado == true) { currentInvitado.ingresado = false} else {currentInvitado.ingresado = true}
      var newMapArray : [[String:Any]] = []
      for invitado in mapInvitados {
         var invitadoMap : [String:Any] = [:]
         invitadoMap["fullname"] = invitado.fullname
         invitadoMap["ingresado"] = invitado.ingresado
         invitadoMap["mail"] = invitado.mail
         invitadoMap["mesa"] = invitado.mesa
         invitadoMap["cantidad"] = invitado.cantidad
         
         newMapArray.append(invitadoMap)
      }
      let array = newMapArray
      self.ref.child("Recepcion").child("juanitoevento").setValue(array)
DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.tableView.reloadData()}
      
   }
   
   func getUserInfo()
   {
      ref.child("Recepcion").child("juanitoevento").observe(.value, with: { (snapshot) in
         
         PKHUD.sharedHUD.hide()
         var invitadoArray : [Invitado] = []
         if let infoArray = snapshot.value as? [[String:Any]] {
            for infomap in infoArray {
               
               let invitado = Invitado (map:infomap)
               invitadoArray.append(invitado)
               
               
            }
            self.mapInvitados = invitadoArray
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.tableView.reloadData()}         }
         // todo ok, empezar a cargar resultados
      }) { (error) in self.displayError()
         //error
         return
      }
   }
   func displayError (message: String = "No pudimos obtener los datos de los invitados, intente mas tarde.") {
      PKHUD.sharedHUD.hide()
      let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
   }


}

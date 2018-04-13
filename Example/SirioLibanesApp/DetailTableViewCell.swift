//
//  DetailTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var switchHabilitado: UISwitch!
    
    @IBOutlet weak var textfieldQR: UITextField!
    
    @IBOutlet weak var textfieldInstagramLink: UITextField!
    
    @IBOutlet weak var textfieldInstagramTag: UITextField!
    
    @IBOutlet weak var textfieldTwitterLink: UITextField!
    
    @IBOutlet weak var textfieldTwitterTag: UITextField!
    
    @IBOutlet weak var textfieldFacebookLink: UITextField!
    
    @IBOutlet weak var textfieldFacebookTag: UITextField!
    
   @IBOutlet weak var textfieldTimestamp: UITextField!
    
    @IBOutlet weak var textfieldURL: UITextField!
    
    @IBOutlet weak var textfieldPhone: UITextField!
    
    @IBOutlet weak var textfieldAddress: UITextField!
    
    @IBOutlet weak var textfieldDescription: UITextField!
    
    @IBOutlet weak var textfieldTitle: UITextField!
    
    @IBOutlet weak var textfieldTwitterApplink: UITextField!
    @IBOutlet weak var textfieldInstagramApplink: UITextField!
    public var datePickerView : UIDatePicker?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView?.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
      
      self.datePickerView = UIDatePicker()
      self.datePickerView!.datePickerMode = .dateAndTime
      self.textfieldTimestamp.inputView = self.datePickerView!
      self.datePickerView!.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
   }
   
   @objc func handleDatePicker() {
      self.textfieldTimestamp.text = String(self.datePickerView!.date.timeIntervalSince1970)
   }

   @IBAction func passAction(_ sender: Any) {
      let textfield = sender as! UITextField
      textfield.resignFirstResponder()
   }
   
}

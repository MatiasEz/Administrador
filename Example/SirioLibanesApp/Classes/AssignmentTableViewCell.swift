//
//  AssignmentTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    @IBOutlet public weak var statusButton: UIButton!
    @IBOutlet public weak var statusSquare: UIView!
    @IBOutlet public weak var assignButton: UIButton!
    @IBOutlet public weak var userStatusLabel: UILabel!
    @IBOutlet public weak var assignmentLabel: UILabel!
    @IBOutlet public weak var userDescriptionLabel: UILabel!
    @IBOutlet public weak var friendLabel: UILabel!
   
   override var tag : Int {
      didSet {
         self.statusButton.tag = self.tag
         self.assignButton.tag = self.tag
      }
   }
   
   
    override func awakeFromNib() {
        super.awakeFromNib()

      self.statusSquare.layer.cornerRadius = 25
      self.selectionStyle = UITableViewCellSelectionStyle.none
    }

}

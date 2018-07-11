//
//  ReceptionTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 25/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ReceptionTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var presenceButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

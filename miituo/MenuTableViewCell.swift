//
//  MenuTableViewCell.swift
//  miituo
//
//  Created by John A. Cristobal on 29/06/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    @IBOutlet var imageicon: UIImageView!    
    @IBOutlet var optionlabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

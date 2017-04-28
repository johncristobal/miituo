//
//  PolizasTableViewCell.swift
//  miituo
//
//  Created by vera_john on 14/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit

class PolizasTableViewCell: UITableViewCell {

    @IBOutlet var imagecar: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageicon: UIImageView!    
    @IBOutlet weak var labelalerta: UILabel!
    
    //@IBOutlet var imagecar: UIImageView!
    //@IBOutlet var label: UILabel!
    //@IBOutlet var imageicon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CurrencyTableViewCell.swift
//  Currency X
//
//  Created by Christian Mansch on 03.09.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lable_fullname: UILabel!
    @IBOutlet weak var label_shorthand: UILabel!
    @IBOutlet weak var label_amount: UILabel!
    
    @IBOutlet weak var country_flag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ItemTableViewCell.swift
//  Flowliner
//
//  Created by Pedro Russo on 10/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var itemLabel: UILabel?
    @IBOutlet weak var itemTextfield: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

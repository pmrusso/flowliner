//
//  TableViewCell.swift
//  Flowliner
//
//  Created by Pedro Russo on 06/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class OutlineTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var outlineNameLabel: UILabel?

    var outline: Outline? {
        didSet {
            outlineNameLabel?.text = outline!.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Table Field Delegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if outline != nil {
            outline?.name = textField.text!
            outlineNameLabel?.text = textField.text!
            outlineNameLabel?.hidden = false
        }
        textField.hidden = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }


}

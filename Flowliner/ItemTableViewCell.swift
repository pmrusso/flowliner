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
    @IBOutlet weak var toggleButton: UIButton?
    
    
    var item: ItemViewModel? {
        didSet {
            itemLabel?.text = item!.text
        }
    }
    
    // MARK: - Table Field Delegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        guard let _ = item else {
            return false
        }
        
        item?.text = textField.text!
        itemLabel?.text = textField.text!
        itemLabel?.hidden = false
        textField.hidden = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

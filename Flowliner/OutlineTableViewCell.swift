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
    @IBOutlet weak var outlineTextfield: UITextField?

    var outline: Outline? {
        didSet {
            outlineNameLabel?.text = outline!.name
        }
    }
    
    
    // MARK: - Table Field Delegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {        
        guard let _ = outline else {
            return false
        }
        
        outline?.name = textField.text!
        outlineNameLabel?.text = textField.text!
        outlineNameLabel?.hidden = false
        textField.hidden = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }


}

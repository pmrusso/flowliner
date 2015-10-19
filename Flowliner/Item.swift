//
//  Item.swift
//  Flowliner
//
//  Created by Pedro Russo on 06/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class Item: NSObject {
    var text: String
    var filepath: String
    var children: [Item]
    
    
    
    init(text: String, filepath: String?, children: [Item]?) {
        self.text = text
        
           if filepath != nil {
            self.filepath = filepath!
        }else {
            self.filepath = ""
        }
        
        if children == nil {
            self.children = [Item]()
        }else {
            self.children = children!
        }
        
        super.init()
    }
    
    convenience init(text:String){
        self.init(text: text, filepath: nil, children: nil)
    }
}

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
        self.filepath = filepath ?? ""
        self.children = children ?? [Item]()        
        super.init()
    }
    
    convenience init(text:String){
        self.init(text: text, filepath: nil, children: nil)
    }
}

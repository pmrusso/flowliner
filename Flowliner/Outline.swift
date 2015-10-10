//
//  Outline.swift
//  Flowliner
//
//  Created by Pedro Russo on 06/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class Outline: NSObject {
    
    var name: String
    var items: [Item]
    
    init(name: String, items: [Item]?)
    {
        self.name = name
        if items != nil {
            self.items = items!
        }else {
            self.items = [Item]()
        }
        super.init()
    }
    
    convenience init (name: String){
        self.init(name: name, items: nil)
    }
}

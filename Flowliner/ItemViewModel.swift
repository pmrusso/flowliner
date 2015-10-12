//
//  ItemViewModel.swift
//  Flowliner
//
//  Created by Pedro Russo on 12/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class ItemViewModel: NSObject {
    var text: String
    var children: [ItemViewModel]
    var showChildren: Bool
    
    init(text: String, children: [ItemViewModel]?, showChildren: Bool)
    {
        self.text = text
        
        if children == nil {
            self.children = []
        }else {
            self.children = children!
        }
        self.showChildren = showChildren
        super.init()
    }
    
    convenience init(item: Item) {
        self.init(text: item.text, children: nil, showChildren: false)
    }
}

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
    var level: Int
    var children: [ItemViewModel]
    var showChildren: Bool
    
    init(text: String, level: Int, children: [ItemViewModel]?, showChildren: Bool)
    {
        self.text = text
        self.level = level
        self.children = children ?? []
        self.showChildren = showChildren
        super.init()
    }
    
    convenience init(item: Item, level: Int) {
        self.init(text: item.text, level: level, children: nil, showChildren: true)
    }
}

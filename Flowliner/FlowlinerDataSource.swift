//
//  FlowlinerDataSource.swift
//  Flowliner
//
//  Created by Pedro Russo on 05/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit


class FlowlinerDataSource: NSObject, UITableViewDataSource {
    
    var outlines = [Outline]()

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return outlines.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! OutlineTableViewCell
        
        cell.outline = outlines[indexPath.row]
        
        // Configure the cell...
        
        return cell
    }

    
}

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
        
        return cell
    }

    // Override to support rearranging the table view.
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedOutline = self.outlines[sourceIndexPath.row]
        self.outlines.removeAtIndex(sourceIndexPath.row)
        self.outlines.insert(movedOutline, atIndex: destinationIndexPath.row)
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
}

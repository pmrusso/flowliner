//
//  DetailTableViewController.swift
//  Flowliner
//
//  Created by Pedro Russo on 10/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, OutlineSelectionDelegate {

    
    var outlineItems: [Item] = []
    var orderedOutlineItems: [Item] = []
    
    var itemViewModels: [ItemViewModel] = []
    var orderedViewModels: [ItemViewModel] = []
    
    func getOrderedItemList(item: Item) -> [Item] {
        var itemList = [item]
        
        for i in item.children {
            itemList += getOrderedItemList(i)
        }
        
        return itemList
    }
    
    func getOrderedItemViewModelList(item: ItemViewModel) -> [ItemViewModel] {
        var itemList = [item]
        
        for i in item.children {
            itemList += getOrderedItemViewModelList(i)
        }
        
        return itemList
    }
    
    func getItemsViewModels(items: [Item]) -> [ItemViewModel]{
        var itemViewModelList = [ItemViewModel]()
        for i in items {
            var itemvm = ItemViewModel(item: i)
            itemvm.children = self.getItemsViewModels(i.children)
            itemViewModelList += [itemvm]
        }
        return itemViewModelList
    }
    
    func outlineSelected(outline: Outline) {
        
        self.itemViewModels = self.getItemsViewModels(outline.items)
        
        self.outlineItems = outline.items
        
        var orderedItems = [Item]()
        for i in outline.items {
            orderedItems += getOrderedItemList(i)
        }
        
        var orderedItemViewModels = [ItemViewModel]()
        for i in self.itemViewModels {
            orderedItemViewModels += getOrderedItemViewModelList(i)
        }
        
        // TODO Change reload data to insert one at a time using depth-first approach
        self.orderedOutlineItems = orderedItems
        self.orderedViewModels = orderedItemViewModels
        tableView.reloadData()
        
        // Currently not working, gotta figure out why
        /*for var index = 0; index < orderedItems.count; ++index {
            self.outlineItems.append(orderedItems[index])
            let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewItem:")
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedOutlineItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell

        // Configure the cell...
        cell.itemLabel!.text = orderedOutlineItems[indexPath.row].text
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    func removeItem(var itemList: [Item], itemToRemove: Item) -> Bool
    {
        var result = false
        if itemList.contains(itemToRemove){
            let index = itemList.indexOf(itemToRemove)
            itemList.removeAtIndex(index!)
            result = true
        }else {
            for i in itemList{
                if removeItem(i.children, itemToRemove: itemToRemove){
                    result = true
                    break;
                }
            }
        }
        return result
    }
    
    func removeItemViewModel(var itemList: [ItemViewModel], itemToRemove: ItemViewModel) -> Bool{
        var result = false
        if itemList.contains(itemToRemove){
            let index = itemList.indexOf(itemToRemove)
            itemList.removeAtIndex(index!)
            result = true
        }else {
            for i in itemList{
                if removeItemViewModel(i.children, itemToRemove: itemToRemove){
                    result = true
                    break;
                }
            }
        }
        return result
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var renameAction = UITableViewRowAction(style: .Normal, title: "Rename", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemTableViewCell? {
                cell.itemLabel?.hidden = true
                cell.itemTextfield?.text = cell.itemLabel?.text
                cell.itemTextfield?.hidden = false
                cell.itemTextfield?.becomeFirstResponder()
                
                /*
                * TODO: Maybe use a popup instead of a textfield...
                */
            }
        })
        
        
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemTableViewCell? {
                let itemToRemove = self.orderedOutlineItems[indexPath.row]
                let itemvmToRemove = self.orderedViewModels[indexPath.row]
                
                self.removeItemViewModel(self.itemViewModels, itemToRemove: itemvmToRemove)
                self.removeItem(self.outlineItems, itemToRemove: itemToRemove)
                
                self.orderedViewModels.removeAtIndex(indexPath.row)
                self.orderedOutlineItems.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        })
        
        return [renameAction,deleteAction]
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let movedItem = self.orderedOutlineItems[fromIndexPath.row]
        self.orderedOutlineItems.removeAtIndex(fromIndexPath.row)
        self.orderedOutlineItems.insert(movedItem, atIndex: toIndexPath.row)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

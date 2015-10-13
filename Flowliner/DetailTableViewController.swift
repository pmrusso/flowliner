//
//  DetailTableViewController.swift
//  Flowliner
//
//  Created by Pedro Russo on 10/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, OutlineSelectionDelegate {

    var itemViewModels: [ItemViewModel] = []
    var orderedViewModels: [ItemViewModel] = []
    var visibleViewModels: [ItemViewModel] = []
    
    private func getOrderedItemList(item: Item) -> [Item] {
        var itemList = [item]
        
        for i in item.children {
            itemList += getOrderedItemList(i)
        }
        
        return itemList
    }
    
    private func getOrderedItemViewModelList(item: ItemViewModel) -> [ItemViewModel] {
        var itemList = [item]
        
        for i in item.children {
            itemList += getOrderedItemViewModelList(i)
        }
        return itemList
    }
    
    func countVisibleChildren(item: ItemViewModel) -> Int{
        var counter = 0
        counter += item.children.count
        
        if item.showChildren{
            for c in item.children {
                counter += countVisibleChildren(c)
            }
        }
        return counter
    }
    
    
    private func toggleVisibleItems(visibleItem: ItemViewModel, indexPath: NSIndexPath)
    {
        if !visibleItem.showChildren
        {
            var visibleItemsToRemoveList: [ItemViewModel] = getOrderedItemViewModelList(visibleItem)
            visibleItemsToRemoveList.removeFirst()
            
            for i in visibleItemsToRemoveList {
                if visibleViewModels.contains(i){
                    let index = visibleViewModels.indexOf(i)
                    let newIndexPath = NSIndexPath(forRow: index!, inSection: 0)
                    visibleViewModels.removeAtIndex(index!)
                    tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                }
            }
        }else {
            let counter = countVisibleChildren(visibleItem)
            let startIndex = orderedViewModels.indexOf(visibleItem)
            
            var j = 1
            
            for var i = startIndex!+1; i <= startIndex!+counter; i++ {
                visibleViewModels.insert(orderedViewModels[i], atIndex: indexPath.row+j)
                let newIndexPath = NSIndexPath(forRow: indexPath.row+j, inSection: 0)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                if !orderedViewModels[i].showChildren {
                    i += getOrderedItemViewModelList(orderedViewModels[i]).count-1
                }
                j++
            }
        }
    }
    
    
    private func removeItemViewModel(var itemList: [ItemViewModel], itemToRemove: ItemViewModel) -> Bool{
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

    
    private func getItemsViewModels(items: [Item]) -> [ItemViewModel]{
        var itemViewModelList = [ItemViewModel]()
        for i in items {
            let itemvm = ItemViewModel(item: i)
            itemvm.children = self.getItemsViewModels(i.children)
            itemViewModelList += [itemvm]
        }
        return itemViewModelList
    }
    
    // MARK: OutlineSelectionDelegate
    
    func outlineSelected(outline: Outline) {
        
        self.itemViewModels = self.getItemsViewModels(outline.items)
        
        var orderedItemViewModels = [ItemViewModel]()
        for i in self.itemViewModels {
            orderedItemViewModels += getOrderedItemViewModelList(i)
        }
        
        // TODO Change reload data to insert one at a time using depth-first approach
        //self.orderedOutlineItems = orderedItems
        self.orderedViewModels = orderedItemViewModels
        self.visibleViewModels = self.orderedViewModels
        tableView.reloadData()
        
        // Currently not working, gotta figure out why
        /*for var index = 0; index < orderedItems.count; ++index {
            self.outlineItems.append(orderedItems[index])
            let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
        }*/
    }
    
    func insertNewItem(sender: AnyObject){
        var newItem = Item(text: "New Item")
        var newItemViewModel = ItemViewModel(item: newItem)
        self.itemViewModels.append(newItemViewModel)
        self.orderedViewModels.append(newItemViewModel)
        self.visibleViewModels.append(newItemViewModel)
        
        let index = self.visibleViewModels.count-1
        let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewItem:")
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
        return visibleViewModels.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell
        cell.item = visibleViewModels[indexPath.row]
        //cell.itemLabel!.text = visibleViewModels[indexPath.row].text
        return cell
    }
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemTableViewCell? {
            var visibeItem = visibleViewModels[indexPath.row]
            visibeItem.showChildren = !visibeItem.showChildren
            self.toggleVisibleItems(visibeItem, indexPath: indexPath)
        }
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
                let itemvmToRemove = self.visibleViewModels[indexPath.row]
                
                self.removeItemViewModel(self.orderedViewModels, itemToRemove: itemvmToRemove)
                self.removeItemViewModel(self.itemViewModels, itemToRemove: itemvmToRemove)
                
                self.visibleViewModels.removeAtIndex(indexPath.row)

                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        })
        
        return [renameAction,deleteAction]
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let movedItem = self.visibleViewModels[fromIndexPath.row]
        self.visibleViewModels.removeAtIndex(fromIndexPath.row)
        self.visibleViewModels.insert(movedItem, atIndex: toIndexPath.row)
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

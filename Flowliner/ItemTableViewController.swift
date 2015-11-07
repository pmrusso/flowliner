//
//  DetailTableViewController.swift
//  Flowliner
//
//  Created by Pedro Russo on 10/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController, OutlineSelectionDelegate {

    var itemViewModels: [ItemViewModel] = []
    var orderedViewModels: [ItemViewModel] = []
    var visibleViewModels: [ItemViewModel] = []
    
    private func getOrderedItemList(item: Item) -> [Item] {
        return item.children.map(getOrderedItemList).reduce([item], combine: +)
    }
    
    private func getOrderedItemViewModelList(item: ItemViewModel) -> [ItemViewModel] {
        return item.children.map(getOrderedItemViewModelList).reduce([item], combine: +)
    }
    
    func countVisibleChildren(item: ItemViewModel) -> Int{
        if item.showChildren {
            return item.children.map(countVisibleChildren).reduce(item.children.count, combine: +)
        }else {
            return 0
        }
    }
    
    private func removeVisibleItem(item: ItemViewModel){
        if visibleViewModels.contains(item){
            let index = visibleViewModels.indexOf(item)
            let newIndexPath = NSIndexPath(forRow: index!, inSection: 0)
            visibleViewModels.removeAtIndex(index!)
            tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        }
    }
    
    private func toggleVisibleItems(visibleItem: ItemViewModel, indexPath: NSIndexPath)
    {
        if !visibleItem.showChildren
        {
            var visibleItemsToRemoveList: [ItemViewModel] = getOrderedItemViewModelList(visibleItem)
            visibleItemsToRemoveList.removeFirst()
            let _ = visibleItemsToRemoveList.map(removeVisibleItem)
        }else {
            let counter = countVisibleChildren(visibleItem)
            let startIndex = orderedViewModels.indexOf(visibleItem)
            
            var j = 1
            
            var orderedIndex = startIndex!+1
            
            for var i = startIndex!+1; i <= startIndex!+counter; i++, j++, orderedIndex++ {
                visibleViewModels.insert(orderedViewModels[orderedIndex], atIndex: indexPath.row+j)
                let newIndexPath = NSIndexPath(forRow: indexPath.row+j, inSection: 0)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                if !orderedViewModels[orderedIndex].showChildren {
                    orderedIndex += getOrderedItemViewModelList(orderedViewModels[orderedIndex]).count-1
                }
                /*j++
                orderedIndex++*/
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

    
    private func getItemsViewModels(items: [Item], level: Int) -> [ItemViewModel]{
        var itemViewModelList = [ItemViewModel]()
        for i in items {
            let itemvm = ItemViewModel(item: i, level: level)
            itemvm.children = self.getItemsViewModels(i.children, level: level+1)
            itemViewModelList += [itemvm]
        }
        return itemViewModelList
        
    }
    
    // MARK: OutlineSelectionDelegate
    
    func buildOrderedViewModels() {
        var orderedItemViewModels = [ItemViewModel]()
        for i in self.itemViewModels {
            orderedItemViewModels += getOrderedItemViewModelList(i)
        }
        
        // TODO Change reload data to insert one at a time using depth-first approach
        //self.orderedOutlineItems = orderedItems
        self.orderedViewModels = orderedItemViewModels
        

    }
    
    func outlineSelected(outline: Outline) {
        
        self.navigationItem.title = outline.name
        
        self.itemViewModels = self.getItemsViewModels(outline.items, level: 0)
        
        self.buildOrderedViewModels()
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
        let newItem = Item(text: "New Item")
        let newItemViewModel = ItemViewModel(item: newItem, level: 0)
        self.itemViewModels.append(newItemViewModel)
        self.orderedViewModels.append(newItemViewModel)
        self.visibleViewModels.append(newItemViewModel)
        
        let index = self.visibleViewModels.count-1
        let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
    }
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer){
        GestureHandlers.moveItemCells(self, tableView: tableView, gestureRecognizer: gestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewItem:")
        self.navigationItem.rightBarButtonItem = addButton
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    func toggleItemVisibility(indexPath: NSIndexPath){
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as! ItemTableViewCell? {
            let visibeItem = visibleViewModels[indexPath.row]
            visibeItem.showChildren = !visibeItem.showChildren
            self.toggleVisibleItems(visibeItem, indexPath: indexPath)
        }
    }
    
    func rotateButton(showChildren: Bool, sender: UIButton){
        
        sender.transform = !showChildren ? CGAffineTransformMakeRotation(CGFloat(M_PI_2)) : CGAffineTransformMakeRotation(CGFloat(0))
    }
    
    @IBAction func toggleChildren(sender: UIButton){
        
        let cell = sender.superview?.superview as! ItemTableViewCell
        let showChildren = cell.item?.showChildren
        
        rotateButton(showChildren!, sender: sender)
        
        let index = visibleViewModels.indexOf(cell.item!)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        
        toggleItemVisibility(indexPath)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleViewModels.count
    }

    func configureCellIdentation(cell: ItemTableViewCell) {
        cell.bounds = CGRectMake(-CGFloat((cell.item?.level)!*20), cell.bounds.minY, cell.bounds.width, cell.bounds.height)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell
        cell.item = visibleViewModels[indexPath.row]
        configureCellIdentation(cell)
        self.rotateButton(!(cell.item?.showChildren)!, sender: cell.toggleButton!)
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        print(proposedDestinationIndexPath.row)
        return proposedDestinationIndexPath
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.toggleItemVisibility(indexPath)
    }*/
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let renameAction = UITableViewRowAction(style: .Normal, title: "Rename", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) in
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
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) in
            if let _ = tableView.cellForRowAtIndexPath(indexPath) as! ItemTableViewCell? {
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
    /*override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        print("move")
        let movedItem = self.visibleViewModels[fromIndexPath.row]
        self.visibleViewModels.removeAtIndex(fromIndexPath.row)
        self.visibleViewModels.insert(movedItem, atIndex: toIndexPath.row)
    }*/
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("move 2")
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

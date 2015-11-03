//
//  GestureHandlers.swift
//  Flowliner
//
//  Created by Pedro Russo on 19/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class GestureHandlers: NSObject {
    
    private static var cellSnapshot: UIView? = nil
    
    private static var initialIndexPath: NSIndexPath? = nil
    
    private static var originalCellColor: UIColor? = nil
    
    private static var targetCell: ItemTableViewCell? = nil
    
    private static var previousIndexPath: NSIndexPath? = nil
    
    private static var canBeParent: Bool = false
    
    static func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }


    static func moveOutlineCells (dataSource: FlowlinerDataSource, tableView: UITableView, gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        switch state{
        case UIGestureRecognizerState.Began:
            if  indexPath != nil {
                self.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! OutlineTableViewCell
                self.cellSnapshot = snapshotOfCell(cell)
                var center = cell.center
                
                self.cellSnapshot!.center = center
                self.cellSnapshot!.alpha = 0.0
                tableView.addSubview(self.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: {() in
                    center.y = locationInView.y
                    self.cellSnapshot!.center = center
                    self.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    self.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { finished in
                        if finished {
                            cell.hidden = true
                        }
                })
            }
            break
        case UIGestureRecognizerState.Changed:
            var center = self.cellSnapshot!.center
            center.y = locationInView.y
            self.cellSnapshot!.center = center
            
            if ((indexPath != nil) && (indexPath != self.initialIndexPath)) {
                swap(&dataSource.outlines[indexPath!.row], &dataSource.outlines[self.initialIndexPath!.row])
                tableView.moveRowAtIndexPath(self.initialIndexPath!, toIndexPath: indexPath!)
                self.initialIndexPath = indexPath
            }
            break
        default:
            let cell = tableView.cellForRowAtIndexPath(self.initialIndexPath!) as! OutlineTableViewCell
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () in
                self.cellSnapshot!.center = cell.center
                self.cellSnapshot!.transform = CGAffineTransformIdentity
                self.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { finished in
                    if finished {
                        self.initialIndexPath = nil
                        self.cellSnapshot!.removeFromSuperview()
                        self.cellSnapshot = nil
                    }
            })
            break
        }

    }
    
    static func moveItemCells (detailViewController: ItemTableViewController, tableView: UITableView, gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        
        
        guard (indexPath != nil) else {
            return }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        let centerDistance = abs(locationInView.y - cell!.center.y)

        
        switch state{
        case UIGestureRecognizerState.Began:
            if  indexPath != nil {
                
                originalCellColor = cell?.backgroundColor
                targetCell = (cell as! ItemTableViewCell)
                
                if targetCell!.item!.showChildren {
                    detailViewController.toggleItemVisibility(indexPath!)
                }
                self.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ItemTableViewCell
                self.cellSnapshot = snapshotOfCell(cell)
                var center = cell.center
                
                self.cellSnapshot!.center = center
                self.cellSnapshot!.alpha = 0.0
                tableView.addSubview(self.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: {() in
                    center.y = locationInView.y
                    self.cellSnapshot!.center = center
                    self.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    self.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: {finished in
                        if finished {
                            cell.hidden = true
                        }
                })
            }
            break
        case UIGestureRecognizerState.Changed:
            var center = self.cellSnapshot!.center
            center.y = locationInView.y
            self.cellSnapshot!.center = center
            
           
            /* 
             * TODO: Place here the code to see if it is a child or a brother
             */
            
            if ((indexPath != nil) && (indexPath != self.initialIndexPath)) {
                
                
                self.targetCell?.backgroundColor = self.originalCellColor
                self.targetCell = (cell as! ItemTableViewCell)
                cell?.backgroundColor = UIColor.orangeColor()
                canBeParent = true
                
                if  centerDistance < 7 {
                    
                
                    let orderedInitialIndex = detailViewController.orderedViewModels.indexOf(detailViewController.visibleViewModels[self.initialIndexPath!.row]);
                    let orderedFinalIndex = detailViewController.orderedViewModels.indexOf(detailViewController.visibleViewModels[indexPath!.row]);
                    
                swap(&detailViewController.visibleViewModels[indexPath!.row], &detailViewController.visibleViewModels[self.initialIndexPath!.row])
                    
                /*
                 * Swap the item and all it's children
                 */
                let childrenList = detailViewController.orderedViewModels[orderedInitialIndex!].children
                swap(&detailViewController.orderedViewModels[orderedFinalIndex!], &detailViewController.orderedViewModels[orderedInitialIndex!])
                
                 var i = 1
                   
                    
                    for _ in  childrenList{
                        
                        if orderedFinalIndex!+i >= detailViewController.orderedViewModels.count {
                            let itemToMove = detailViewController.orderedViewModels.removeAtIndex(orderedInitialIndex!+i)
                            detailViewController.orderedViewModels.append(itemToMove)
                        }else{
                        
                        swap(&detailViewController.orderedViewModels[orderedFinalIndex!+i], &detailViewController.orderedViewModels[orderedInitialIndex!+i])
                        }
                            i++;
                    }
                    
                
                    
                detailViewController.tableView.moveRowAtIndexPath(self.initialIndexPath!, toIndexPath: indexPath!)
                
                
                self.previousIndexPath = self.initialIndexPath
                self.initialIndexPath = indexPath
                canBeParent = false
                    
                }else {
                    // Show some highlight of the cell
                  
                }
                
            }else {
                targetCell?.backgroundColor = originalCellColor
            }
            break
        default:
            
            targetCell?.backgroundColor = originalCellColor
            
            var cell = tableView.cellForRowAtIndexPath(self.initialIndexPath!) as! ItemTableViewCell
            
            // Check if I have to switch the item from one parent to another
            

            
            if (indexPath != nil) && (indexPath != self.initialIndexPath) {
            
               let distanceToTarget = abs(abs(locationInView.y - targetCell!.center.y))
             
            
               if canBeParent {
                 print("canBeParent")
                    // Make child of target Cell
                    let targetIndex = detailViewController.orderedViewModels.indexOf((targetCell?.item!)!)
                
                if !targetCell!.item!.showChildren {
                    detailViewController.toggleItemVisibility(indexPath!)
                }
                
                /*
                 * Must test if moving cell is up or bottom
                 */
                
                /*
                 * Testing block
                 */
                let itemViewModel = detailViewController.visibleViewModels[(initialIndexPath?.row)!]
                
                var parent: ItemViewModel?
                
                for i in detailViewController.orderedViewModels{
                    if i.children.contains(itemViewModel) {
                        parent = i
                        break
                    }
                }
                
                if parent != nil {
                
                let parentIndex = detailViewController.orderedViewModels.indexOf(parent!)
                let itemChildrenIndex = detailViewController.orderedViewModels[parentIndex!].children.indexOf(itemViewModel)
                detailViewController.orderedViewModels[parentIndex!].children.removeAtIndex(itemChildrenIndex!)
                }else {
                    let itemIndex = detailViewController.itemViewModels.indexOf(itemViewModel)
                    detailViewController.itemViewModels.removeAtIndex(itemIndex!)
                }
                
                
                
                detailViewController.visibleViewModels[indexPath!.row].children.insert(itemViewModel, atIndex: 0)
                
                /*
                 * TODO: Do this to all it's children, try recursive
                 */
                
                let modifiedViewModel = detailViewController.visibleViewModels[indexPath!.row+1]
                modifiedViewModel.level = detailViewController.visibleViewModels[indexPath!.row].level + 1
                
                for i in modifiedViewModel.children {
                    updateItemIdentation(i, level: modifiedViewModel.level)
                }
                canBeParent = false
                
                detailViewController.buildOrderedViewModels()
                /*
                 * END Testing block
                 */
                
                
            }else {
               print("n sei o q fazer aqui")
            }
            
            
            }else {
                print("Cannot be parent")

                let targetIndex = detailViewController.orderedViewModels.indexOf((targetCell?.item!)!)
                
                
                /*
                * Testing block
                */
                let itemViewModel = detailViewController.visibleViewModels[(initialIndexPath?.row)!]
                
                var parent: ItemViewModel?
                
                for i in detailViewController.orderedViewModels{
                    if i.children.contains(itemViewModel) {
                        parent = i
                        break
                    }
                }
                
                if parent != nil {
                    
                    let parentIndex = detailViewController.orderedViewModels.indexOf(parent!)
                    let itemChildrenIndex = detailViewController.orderedViewModels[parentIndex!].children.indexOf(itemViewModel)
                    detailViewController.orderedViewModels[parentIndex!].children.removeAtIndex(itemChildrenIndex!)
                }else {
                    let itemIndex = detailViewController.itemViewModels.indexOf(itemViewModel)
                    detailViewController.itemViewModels.removeAtIndex(itemIndex!)
                }
                
                
                if (initialIndexPath?.row)!-1 < 0 {
                    detailViewController.itemViewModels.insert(itemViewModel, atIndex: 0)
                    itemViewModel.level = 0
                }else if (initialIndexPath?.row)!+1 >= detailViewController.visibleViewModels.count {
                    detailViewController.itemViewModels.append(itemViewModel)
                    itemViewModel.level = 0
                }else {
                
                
                let itemViewModel1: ItemViewModel = detailViewController.visibleViewModels[(initialIndexPath?.row)!-1]
                let itemViewModel2: ItemViewModel = detailViewController.visibleViewModels[(initialIndexPath?.row)!+1]
                
                var parent1: ItemViewModel?
                var parent2: ItemViewModel?
                
                
                
                for i in detailViewController.orderedViewModels{
                    if i.children.contains(itemViewModel1) {
                        parent1 = i
                        break
                    }
                }
                for i in detailViewController.orderedViewModels{
                    if i.children.contains(itemViewModel2) {
                        parent2 = i
                        break
                    }
                }

                
                if (parent1 == nil && parent2 == nil) {
                    
                    let highIndex = detailViewController.itemViewModels.indexOf(itemViewModel2)
                    detailViewController.itemViewModels.insert(itemViewModel, atIndex: highIndex!)
                    itemViewModel.level = 1
                }else if parent1 != parent2 && parent2 != nil{
                    let index = parent2?.children.indexOf(itemViewModel2)
                    parent2?.children.insert(itemViewModel, atIndex: index!)
                    itemViewModel.level = (parent2?.level)! + 1
                }else {
                    let index = parent1?.children.indexOf(itemViewModel1)
                    parent1?.children.insert(itemViewModel, atIndex: index!+1)
                    itemViewModel.level = (parent1?.level)!+1
                }
                    
                    
                canBeParent = false
                print("end cannot be parent")
                
             
            }
            detailViewController.buildOrderedViewModels()

                for i in itemViewModel.children {
                    updateItemIdentation(i, level: itemViewModel.level)
                }

            

            
    }
            tableView.reloadRowsAtIndexPaths([initialIndexPath!], withRowAnimation: .None)
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () in
                self.cellSnapshot!.center = cell.center
                self.cellSnapshot!.transform = CGAffineTransformIdentity
                self.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { finished in
                    if finished {
                        self.initialIndexPath = nil
                        self.cellSnapshot!.removeFromSuperview()
                        self.cellSnapshot = nil
                    }
            })
            break
            
}
        
    
    }
    
    static func updateItemIdentation(item: ItemViewModel, level: Int) {
        item.level = level + 1
        for i in item.children{
            updateItemIdentation(i, level: item.level)
        }
    }
}

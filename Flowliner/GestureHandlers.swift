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
        
        switch state{
        case UIGestureRecognizerState.Began:
            if  indexPath != nil {
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
            
            if ((indexPath != nil) && (indexPath != self.initialIndexPath)) {
                swap(&detailViewController.visibleViewModels[indexPath!.row], &detailViewController.visibleViewModels[self.initialIndexPath!.row])
                tableView.moveRowAtIndexPath(self.initialIndexPath!, toIndexPath: indexPath!)
                self.initialIndexPath = indexPath
            }
            break
        default:
            let cell = tableView.cellForRowAtIndexPath(self.initialIndexPath!) as! ItemTableViewCell
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

    
}

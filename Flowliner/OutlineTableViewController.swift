//
//  MasterViewController.swift
//  Flowliner
//
//  Created by Pedro Russo on 01/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

protocol OutlineSelectionDelegate: class {
    func outlineSelected(outline: Outline)
}

class OutlineTableViewController: UITableViewController, UISplitViewControllerDelegate {

    @IBOutlet weak var dataSource: FlowlinerDataSource!
    weak var delegate: OutlineSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
        
        
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewOutline:")
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer){
        GestureHandlers.moveOutlineCells(dataSource, tableView: tableView, gestureRecognizer: gestureRecognizer)
    }
    
        
    private func selectRowAtIndexPath(indexPath: NSIndexPath) {
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as! OutlineTableViewCell? {
            let selectedOutline = self.dataSource.outlines[indexPath.row]
            self.delegate?.outlineSelected(selectedOutline)
        }
    }
    
    
    func addNewOutline(sender: AnyObject){
        let newoutline = Outline(name: "New Oultine")
        dataSource.outlines.append(newoutline)
        let index = dataSource.outlines.count-1
        let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
    }
    

    // MARK: Table View Controller
    
    private func createTextField(delegate: OutlineTableViewCell) -> UITextField
    {
        let tf = UITextField(frame: CGRectMake(60, 0, 250, 44))
        print(tf.frame)
        tf.delegate = delegate
        tf.contentHorizontalAlignment = .Right
        tf.contentVerticalAlignment = .Center
        return tf
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let renameAction = UITableViewRowAction(style: .Normal, title: "Rename", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) in
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as! OutlineTableViewCell? {
                cell.outlineNameLabel?.hidden = true
                cell.outlineTextfield?.text = cell.outlineNameLabel?.text
                cell.outlineTextfield?.hidden = false
                cell.outlineTextfield?.becomeFirstResponder()
                
                /*
                 * TODO: Maybe use a popup instead of a textfield...
                 */
            }
        })
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) in
            if let _ = tableView.cellForRowAtIndexPath(indexPath) as! OutlineTableViewCell? {
                self.dataSource.outlines.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        })
        
        return [renameAction,deleteAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectRowAtIndexPath(indexPath)
        if let detailViewController = self.delegate as? ItemTableViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
     }
    }
    
        
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
       
       

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    // MARK: UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    

}
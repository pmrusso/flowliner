//
//  MasterViewController.swift
//  Flowliner
//
//  Created by Pedro Russo on 01/10/15.
//  Copyright © 2015 Pedro Russo. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    @IBOutlet weak var dataSource: FlowlinerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.outlines += [Outline(name: "Mike"), Outline(name:"Paul")]
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewOutline:")
        self.navigationItem.rightBarButtonItem = addButton
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func selectRowAtIndexPath(indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as! OutlineTableViewCell? {
            // add stuff here
        }
    }
    
    
    func insertNewOutline(sender: AnyObject){
        let newoutline = Outline(name: "New Oultine")
        dataSource.outlines.append(newoutline)
        let index = dataSource.outlines.count-1
        let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source


    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

  /*  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }*/
    

    // MARK: Table View Controller
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
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
        var renameAction = UITableViewRowAction(style: .Default, title: "Rename", handler:{ (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as! OutlineTableViewCell? {
                let textField = self.createTextField(cell)
                cell.outlineNameLabel?.hidden = true
                cell.addSubview(textField)
                textField.text = cell.outlineNameLabel?.text
                textField.becomeFirstResponder()
            }
        })
        
        return [renameAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectRowAtIndexPath(indexPath)
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

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

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

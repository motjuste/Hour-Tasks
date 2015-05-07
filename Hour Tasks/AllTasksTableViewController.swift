//
//  AllTasksTableViewController.swift
//  Hour Tasks
//
//  Created by Abdullah on 06/05/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import UIKit
import CoreData

class AllTasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController =  NSFetchedResultsController(
            fetchRequest: taskFetchRequest(),
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        let sortDescriptor = NSSortDescriptor(key: "deadline", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func markDone(sender: UIButton) {
        
        if let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0) {
            let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Tasks
            
            if task.done {
                task.done = false
            } else {
                task.done = true
            }
            
            managedObjectContext?.save(nil)
        } else {
            println("Error Here")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return fetchedResultsController.sections![section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: AllTasksTableViewCell = tableView.dequeueReusableCellWithIdentifier("AllTasksTableViewCell", forIndexPath: indexPath) as! AllTasksTableViewCell

        let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Tasks
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        cell.taskDesc?.attributedText = NSAttributedString(string: task.desc)
        cell.deadline?.attributedText = NSAttributedString(string: dateFormatter.stringFromDate(task.deadline))
        cell.doneButton?.tag = indexPath.row
        cell.doneButton?.addTarget(self, action: "markDone:", forControlEvents: .TouchUpInside)
        
        
        if task.done {
            let strikeThroughAttribute = [NSStrikethroughStyleAttributeName: 2]
            
            cell.taskDesc?.attributedText = NSAttributedString(string: task.desc, attributes: strikeThroughAttribute)
            cell.taskDesc?.enabled = false
            
//            cell.deadline?.attributedText = NSAttributedString(string: dateFormatter.stringFromDate(task.deadline), attributes: strikeThroughAttribute)
            cell.deadline?.enabled = false
        } else {
            cell.taskDesc?.enabled = true
            cell.deadline?.enabled = true
        }
            
        
        
        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
        
        let managedObject: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext?.deleteObject(managedObject)
        managedObjectContext?.save(nil)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let taskEditingController = segue.destinationViewController as! AddBoringTaskViewController
            let task = fetchedResultsController.objectAtIndexPath(indexPath!) as! Tasks
            taskEditingController.task = task
        }
    }

}

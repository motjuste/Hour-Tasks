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
    
    @IBAction func changeSorting(sender: AnyObject) {
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.performFetch(nil)
        tableView.reloadData()
    }
    
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        // Doesn't work for priority !!!!!
        
        let segmentControlNav = self.navigationItem.titleView as! UISegmentedControl
        var sectionNameKey = ""
        switch segmentControlNav.selectedSegmentIndex    {
        case 0 :
            sectionNameKey = "deadlineDate"
        case 1 :
            sectionNameKey = "priority"
        default:
            sectionNameKey = "deadlineDate"
        }
        fetchedResultsController =  NSFetchedResultsController(
                fetchRequest: taskFetchRequest(),
                managedObjectContext: managedObjectContext!,
                sectionNameKeyPath: sectionNameKey, cacheName: nil)
            
        
        return fetchedResultsController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        let deadlineSortDescriptor = NSSortDescriptor(key: "deadline", ascending: true)
        let prioritySortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        fetchRequest.sortDescriptors = [deadlineSortDescriptor, prioritySortDescriptor]
        return fetchRequest
    }
    
    func markDone(sender: UITableViewCell) {
        let indexPath = self.tableView.indexPathForCell(sender)
//        if let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0) {
            let task = fetchedResultsController.objectAtIndexPath(indexPath!) as! Tasks
            if task.done {
                task.done = false
            } else {
                task.done = true
            }
            
            managedObjectContext?.save(nil)
//        } else {
//            println("Error Here")
//        }
        
//        println(indexPath.row)
//        println(indexPath.section)
        
        tableView.reloadData()

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
        
        let segmentControlNav = self.navigationItem.titleView as! UISegmentedControl
        segmentControlNav.selectedSegmentIndex = 0
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
        
        cell.doneButton?.addTarget(cell, action: "markDone:", forControlEvents: .TouchUpInside)
        
        let priorityString = "!!!"
        cell.priorityLabel?.text = priorityString.substringToIndex(advance(priorityString.startIndex, Int(task.priority)))
        
        
        if task.done {
            let strikeThroughAttribute = [NSStrikethroughStyleAttributeName: 2]
            
            cell.taskDesc?.attributedText = NSAttributedString(string: task.desc, attributes: strikeThroughAttribute)
            cell.taskDesc?.enabled = false
            cell.deadline?.enabled = false
            cell.priorityLabel.enabled = false
            
            // #4CAF50
            cell.doneButton?.backgroundColor = UIColor(red: 0x1D/255, green: 0xE9/255, blue: 0xB6/255, alpha: 1.0)
        } else {
            cell.taskDesc?.enabled = true
            cell.deadline?.enabled = true
            cell.doneButton?.backgroundColor = UIColor.groupTableViewBackgroundColor()
            cell.priorityLabel.enabled = true
        }
            
        
        
        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSection = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        let currString = currentSection.name
        let segNavCon = self.navigationItem.titleView as! UISegmentedControl
        switch segNavCon.selectedSegmentIndex {
        case 0:
                return currString?.substringToIndex(advance(currString!.startIndex, 10))
        case 1 :
                let priorityString = "!!!"
                return  priorityString.substringToIndex(advance(priorityString.startIndex, currString!.toInt()! + 1))
        default:
                return currString
        }
        
        
    }
    
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

//
//  AddBoringTaskViewController.swift
//  Hour Tasks
//
//  Created by Abdullah on 07/05/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import UIKit
import CoreData

class AddBoringTaskViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var task:Tasks? = nil
    
    @IBOutlet weak var taskDesc: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySelection: UISegmentedControl!
    
    // Navigation and saving
    @IBAction func done(sender: AnyObject) {
        if task != nil {
            editTask()
        } else {
            createTask()
        }
        dismissAddNewTaskVC()
    }
    
    func editTask() {
        task?.desc = taskDesc.text
        task?.deadline = datePicker.date
        task?.done = false
        task?.priority = Int16(prioritySelection.selectedSegmentIndex + 1)
        managedObjectContext?.save(nil)
    }
    
    func createTask() {
        let entityDescription = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: managedObjectContext!)
        let task = Tasks(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        task.desc = taskDesc.text
        task.deadline = datePicker.date
        task.done = false
        task.priority = Int16(prioritySelection.selectedSegmentIndex + 1)
        managedObjectContext!.save(nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissAddNewTaskVC()
    }
    
    func dismissAddNewTaskVC() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Add New Task"

        if task != nil {
            self.navigationItem.title = "Edit Task"
            taskDesc?.text = task!.desc
            datePicker?.setDate(task!.deadline, animated: true)
            prioritySelection.selectedSegmentIndex = Int(task!.priority - 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

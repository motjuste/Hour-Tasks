//
//  AddNewTaskViewController.swift
//  Hour Tasks
//
//  Created by Abdullah on 06/05/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import UIKit

class AddNewTaskViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Navigation
    @IBAction func addNewTask(sender: AnyObject) {
        dismissAddNewTaskVC()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissAddNewTaskVC()
    }
    
    func dismissAddNewTaskVC() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Adding Tasks
    @IBOutlet weak var newTaskDesc: UITextField!
    @IBOutlet weak var displayedDeadline: UILabel!
    @IBOutlet weak var slotsCollectionView: UICollectionView!
    
    func dateTimeToSlotIndexPath (dateTime: NSDate, collectionView: UICollectionView) -> NSIndexPath {
        let indexPath = NSIndexPath(index: 0)
        
        return indexPath
    }
    
    func slotIndexPathToDateTime (collectionView: UICollectionView, indexPath: NSIndexPath) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.CalendarUnitHour,
            value: indexPath.row,
            toDate: NSDate(),
            options: nil)!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedDate: NSDate = slotIndexPathToDateTime(collectionView, indexPath: indexPath)
        
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = collectionView.tintColor
        
        updateDisplayedDeadline(selectedDate)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    func updateDisplayedDeadline(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EE, MMMM d, h a"
        
        displayedDeadline.text = dateFormatter.stringFromDate(date)
    }
    
    // Mandatory methods for UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 * 10
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // preselect the best slot  NOT WORKING!!
        slotsCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Top)
        slotsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))?.backgroundColor = slotsCollectionView.tintColor
        
        updateDisplayedDeadline(slotIndexPathToDateTime(slotsCollectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0)))
        
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

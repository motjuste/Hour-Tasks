//
//  Tasks.swift
//  Hour Tasks
//
//  Created by Abdullah on 07/05/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import Foundation
import CoreData

class Tasks: NSManagedObject {

    @NSManaged var deadline: NSDate
    @NSManaged var desc: String
    @NSManaged var done: Bool
    @NSManaged var priority: Int16
    var deadlineDate: NSDate {
        let cal = NSCalendar.currentCalendar()
        let components = cal.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: deadline)
        return cal.dateFromComponents(components)!
    }

}

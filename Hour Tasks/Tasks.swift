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

    @NSManaged var desc: String
    @NSManaged var deadline: NSDate

}

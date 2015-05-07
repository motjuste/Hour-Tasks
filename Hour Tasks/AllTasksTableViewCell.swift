//
//  AllTasksTableViewCell.swift
//  Hour Tasks
//
//  Created by Abdullah on 07/05/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import UIKit

class AllTasksTableViewCell: UITableViewCell {

    
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

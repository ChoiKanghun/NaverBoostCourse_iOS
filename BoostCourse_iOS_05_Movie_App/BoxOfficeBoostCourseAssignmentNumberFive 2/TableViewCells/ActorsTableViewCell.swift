//
//  ActorsTableViewCell.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/06.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ActorsTableViewCell: UITableViewCell {

    @IBOutlet weak var directorUILabel: UILabel!
    @IBOutlet weak var charactersUILabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

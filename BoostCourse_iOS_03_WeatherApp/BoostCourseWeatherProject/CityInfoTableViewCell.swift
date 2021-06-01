//
//  CityInfoTableViewCell.swift
//  BoostCourseWeatherProject
//
//  Created by 최강훈 on 2020/10/19.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class CityInfoTableViewCell: UITableViewCell {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempInLabel: UILabel!
    @IBOutlet var rainProbabilityLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!

    
    let cityCellIdentifier: String = "customCell"

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

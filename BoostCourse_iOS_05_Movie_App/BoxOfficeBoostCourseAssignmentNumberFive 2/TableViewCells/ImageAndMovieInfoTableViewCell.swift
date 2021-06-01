//
//  ImageAndMovieInfoTableViewCell.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/06.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ImageAndMovieInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var ageLimitImageView: UIImageView!
    @IBOutlet weak var openingDateUILabel: UILabel!
    @IBOutlet weak var genreUILabel: UILabel!
    @IBOutlet weak var duartionUILabel: UILabel!
    @IBOutlet weak var rankingUILabel: UILabel!
    @IBOutlet weak var ratingUILabel: UILabel!
    @IBOutlet weak var audienceUILabel: UILabel!
        

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

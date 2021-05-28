//
//  MovieListCellTableViewCell.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/04.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class MovieListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieRanking: UILabel!
    @IBOutlet weak var movieReservationRate: UILabel!
    @IBOutlet weak var movieOpeningDate: UILabel!
    @IBOutlet weak var ageLimitImageView: UIImageView!
    var movieId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

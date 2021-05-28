//
//  MovieListCollectionViewCell.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/30.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var openingDateLabel: UILabel!
    @IBOutlet weak var ageLimitImageView: UIImageView!
    
    var movieId: String?
}


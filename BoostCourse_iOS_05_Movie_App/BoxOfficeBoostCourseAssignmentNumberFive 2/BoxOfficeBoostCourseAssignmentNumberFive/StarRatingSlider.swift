//
//  StarRatingSlider.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/20.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class StarRatingSlider: UISlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
}

//
//  OrderTypes.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2021/06/24.
//  Copyright © 2021 최강훈. All rights reserved.
//

import Foundation

enum OrderType: Int, CustomStringConvertible {
    case reservationRate = 0
    case curation = 1
    case openingDate = 2
    
    var description: String {
        switch self {
        case .reservationRate:
            return "예매율"
        case .curation:
            return "큐레이션"
        case .openingDate:
            return "개봉일"
        }
    }
    
}

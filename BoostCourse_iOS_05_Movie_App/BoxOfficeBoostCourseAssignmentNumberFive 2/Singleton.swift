//
//  Singleton.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/30.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

class Singleton {
    static let shared: Singleton = Singleton()
    
    var ageLimitImageName: String?
    
    var tableViewTitleOrder: String?
    var orderType: OrderType?

}

enum OrderTypeString: String {
     case reservationRate = "예매율"
     case curation = "큐레이션"
     case openingDate = "개봉일"
 }

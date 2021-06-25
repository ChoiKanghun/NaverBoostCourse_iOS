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
    var postCommentUserId: String?
    
    private init() {}
    

}

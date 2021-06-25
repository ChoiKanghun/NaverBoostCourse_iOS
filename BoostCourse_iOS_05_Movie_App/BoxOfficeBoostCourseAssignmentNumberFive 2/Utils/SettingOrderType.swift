//
//  SettingOrderType.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2021/06/25.
//  Copyright © 2021 최강훈. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func setOrderTypeAndTitle (orderType: Int, viewController: UIViewController) {
        
        if let value = OrderType.init(rawValue: orderType) {
            Singleton.shared.orderType = value
            Singleton.shared.tableViewTitleOrder = value.description + "순"
            // set title
            viewController.navigationItem.title = Singleton.shared.tableViewTitleOrder
            NotificationCenter.default.post(name: DidReceiveOrderTypeNotification, object: orderType)
        }
    }
}

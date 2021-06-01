//
//  UserInterface.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation
import UIKit

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    private init() {}
    
    var id: String?
    var password: String?
    var selfIntroduce: String?
    var profileImage: UIImage?
    var phoneNumber: String?
    var dateLabel: String?
    var datePickerDate: Date?
}

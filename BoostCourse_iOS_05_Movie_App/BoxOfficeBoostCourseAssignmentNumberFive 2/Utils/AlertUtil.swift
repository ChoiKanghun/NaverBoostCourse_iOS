//
//  AlertUtil.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2021/06/25.
//  Copyright © 2021 최강훈. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    private init() {}
    
    static func justAlert(VC: UIViewController, title: String, message: String?, preferredStyle: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okAction)
        
        VC.present(alert, animated: true, completion: nil)
    }
    
    static func alertAndDismiss(viewController: UIViewController, title: String, message: String?, preferredStyle: UIAlertController.Style, completion: @escaping (Bool?) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

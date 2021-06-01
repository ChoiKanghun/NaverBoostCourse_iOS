//
//  File.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation
import UIKit

// MARK:- for the next button
 
class DefaultBtn: UIButton {
        
     // 1. when initializing with storyBoard
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
            
        setUp()
    }
     
     // 2. when initializing with code
     override init(frame: CGRect) {
         super.init(frame: frame)
         
        setUp()
     }
     
     enum btnState {
         case On
         case Off
     }
     
     // default state is off
     var isOn: btnState = .Off
     
     // color of state of On
     let onTintColor: UIColor = UIColor(red: 0, green: 1/255, blue: 255/255, alpha: 1)
     
     // color of state of Off
     let offTintColor: UIColor = .gray
     
     func setUp() {
         switch isOn {
         case .On:
             self.setTitleColor(onTintColor, for: .normal)
             self.isUserInteractionEnabled = true
         case .Off:
             self.setTitleColor(offTintColor, for: .normal)
             self.isUserInteractionEnabled = false
         }
     }
 }


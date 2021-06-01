//
//  NextButton.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/16.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

// MARK:- for the next button
 
 class DefaultBtn: UIButton {
     // 1. when initializing with storyBoard
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         
         setting()
     }
     
     // 2. when initializing with code
     override init(frame: CGRect) {
         super.init(frame: frame)
         
         setting()
     }
     
     enum btnState {
         case On
         case Off
     }
     
     // default state is off
     var isOn: btnState = .Off
     
     // color of state of On
     var onTintColor: UIColor = UIColor(red: 0, green: 122/255, blue: 1/255, alpha: 1)
     
     // color of state of Off
     var offTintColor: UIColor = .gray
     
     func setting() {
         
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

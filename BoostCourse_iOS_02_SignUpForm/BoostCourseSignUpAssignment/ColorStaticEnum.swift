//
//  ColorStaticEnum.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/20.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation
import UIKit

class DefaultButton: UIButton {
    enum btnState {
        case On
        case Off
    }
    
    var isOn: btnState = .Off {
        didSet {
            setting()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    let onTintColor: UIColor = UIColor(red: 0, green: 0/255, blue: 255/255, alpha: 1)
    let offTintColor: UIColor = .gray

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

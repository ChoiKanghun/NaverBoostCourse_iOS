//
//  ViewController.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/12.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBOutlet var idField: UITextField!
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        if let idText = UserInformation.shared.id {
            self.idField.text = idText
            UserInformation.shared.id = nil
            UserInformation.shared.password = nil
            UserInformation.shared.profileImage = nil
            UserInformation.shared.selfIntroduce = nil
            UserInformation.shared.phoneNumber = nil
            UserInformation.shared.dateLabel = nil
            UserInformation.shared.datePickerDate = nil
        }
    }
    
    // MARK:- on Tap blank area keydown
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}


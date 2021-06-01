//
//  PhoneNumberDatePickingViewController.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/15.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class PhoneNumberDatePickingViewController: UIViewController, UITextFieldDelegate {
    // MARK:- Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var submitButton: DefaultBtn!
    
    //MARK:- For keyboard down on tap blank area
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // MARK:- For Cancellation and Previous and SignUp Button
    @IBAction func onClickPreviousButton(_ sender: UIButton) {
        if let dateStr = self.dateLabel.text {
            UserInformation.shared.dateLabel = dateStr
        }
        if let phoneNum = self.phoneNumberTextField.text {
            UserInformation.shared.phoneNumber = phoneNum
        }
        UserInformation.shared.datePickerDate = self.datePicker.date
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickSubmitBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    @IBAction func onClickCancellationButton(_ sender: Any) {
        UserInformation.shared.id = nil
        UserInformation.shared.password = nil
        UserInformation.shared.profileImage = nil
        UserInformation.shared.selfIntroduce = nil
        UserInformation.shared.phoneNumber = nil
        UserInformation.shared.dateLabel = nil
        UserInformation.shared.datePickerDate = nil
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }

    // MARK:- date Formatter
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        return formatter
    }()
    
    // MARK:- set dateLabel text on datePicker value change
    @IBAction func onDatePickerValueChange(_ sender: UIDatePicker) {
        let date: Date = sender.date
        let dateString: String = self.dateFormatter.string(from: date)
        
        self.dateLabel.text = dateString
        checkAllFieldsAreNotEmpty()
    }
    
    // MARK:- on phone number change
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkAllFieldsAreNotEmpty()
    }

    // MARK:- for the submit button
    override func viewDidLoad() {
        super.viewDidLoad()

        // if UserInformation has phoneNumber or DateLabel info
        if let dateStr = UserInformation.shared.dateLabel {
             self.dateLabel.text = dateStr
        } else {
            let date: Date = self.datePicker.date
            let dateString: String = self.dateFormatter.string(from: date)
            self.dateLabel?.text = dateString
        }
        if let phoneNum = UserInformation.shared.phoneNumber {
             self.phoneNumberTextField.text = phoneNum
        }
        if let datePickerDate = UserInformation.shared.datePickerDate {
            self.datePicker.date = datePickerDate
        }
        // set submitButton disabled
        submitButton.setTitleColor(submitButton.offTintColor, for: .normal)
        submitButton.isUserInteractionEnabled = false
        phoneNumberTextField.delegate = self
    }
    
    func checkAllFieldsAreNotEmpty() {
        if dateLabel.text?.isEmpty == true ||
            phoneNumberTextField.text?.isEmpty == true {
            submitButton.setTitleColor(submitButton.offTintColor, for: .normal)
            submitButton.isUserInteractionEnabled = false
        } else {
            submitButton.setTitleColor(submitButton.onTintColor, for: .normal)
            submitButton.isUserInteractionEnabled = true
        }
    }
}

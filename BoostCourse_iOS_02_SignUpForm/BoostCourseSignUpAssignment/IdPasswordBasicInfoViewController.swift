//
//  IdPasswordBasicInfoViewController.swift
//  BoostCourseSignUpAssignment
//
//  Created by 최강훈 on 2020/10/12.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class IdPasswordBasicInfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK:- Properties
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var nextButton: DefaultBtn!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var selfIntroduceField: UITextView!
    @IBOutlet weak var checkPasswordTextField: UITextField!

    // MARK:- Methods for ImagePicker Controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.imageView.image = editedImage
            checkAllFieldsAreNotEmpty()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nextButton's default state is Off
        nextButton.isOn = .Off

        // on touch imageView, it allows user to enroll image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        imagePicker.delegate = self
        selfIntroduceField.delegate = self
        idField.delegate = self
        passwordField.delegate = self
        checkPasswordTextField.delegate = self

        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        
    }
    @objc func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - codes for cancel, next button
    @IBAction func touchUpSetIdPwButton(_ sender: UIButton) {
        UserInformation.shared.id = idField.text
        UserInformation.shared.password = passwordField.text
        UserInformation.shared.profileImage = imageView.image
        UserInformation.shared.selfIntroduce = selfIntroduceField.text
    }
    @IBAction func touchUpDeleteIdPwButton(_ sender: UIButton) {
        UserInformation.shared.id = nil
        UserInformation.shared.password = nil
        UserInformation.shared.profileImage = nil
        UserInformation.shared.selfIntroduce = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- on editing textFields, textView: checkAllFieldsAreNotEmpty
    @IBAction func editChanged(_ sender: UITextField) {
        checkAllFieldsAreNotEmpty()
    }
    func textViewDidChange(_ textView: UITextView) {
        checkAllFieldsAreNotEmpty()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkAllFieldsAreNotEmpty()
    }
    func checkAllFieldsAreNotEmpty() {
        if imageView.image == nil || idField.text?.isEmpty == true || passwordField.text?.isEmpty == true || checkPasswordTextField.text?.isEmpty == true ||
            selfIntroduceField.text?.isEmpty == true ||
            passwordField.text != checkPasswordTextField.text {
            // last condition is to check password is same or not
            nextButton.setTitleColor(nextButton.offTintColor, for: .normal)
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.setTitleColor(nextButton.onTintColor, for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    // MARK:- on Tap blank area keydown
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

//
//  PostCommentViewController.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/15.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

let DidDismissPostCommentViewController: Notification.Name = Notification.Name("DidDismissPostCommentViewController")

class PostCommentViewController: UIViewController {

    @IBOutlet weak var movieTitleUILabel: UILabel!
    @IBOutlet weak var starRatingUILabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var ageLimitUIImageView: UIImageView!
    @IBOutlet weak var starSlider: UISlider!
    
    var titleToSet: String?
    var movieId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageName = Singleton.shared.ageLimitImageName
            else {return}
        self.ageLimitUIImageView?.image = UIImage(named: imageName)
        self.starRatingUILabel?.text = String(10)
        self.starSlider.value = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieTitleUILabel?.text = titleToSet
    }
    

    @IBAction func onDragStarSlider(_ sender: UISlider) {
        let floatValue = floor(sender.value * 10) / 10
        let intValue = Int(floor(sender.value))
        
        for index in 0...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= intValue / 2 {
                    starImage.image = UIImage(named: "ic_star_large_full")
                } else {
                    if (2 * index - intValue) <= 1 {
                        starImage.image = UIImage(named: "ic_star_large_half")
                    } else {
                        starImage.image = UIImage(named: "ic_star_large")
                    }
                }
            }
            self.starRatingUILabel?.text = String(Int(floatValue))
        }
    }
    
    @IBAction func touchUpPostButton(_ sender: Any) {
        
        guard let movieId = self.movieId else {
            alertFunc(message: "확인할 수 없는 movie_id")
            return}
        guard let writer = self.userNameTextField.text else {
            return}
        guard let contents = self.commentTextView.text else {
            return}
        if self.userNameTextField.text == "" || self.commentTextView.text == "" {
            alertFunc(message: "작성자와 내용 모두 입력하셔야 합니다.")
            return
        }
        RequestUtils.shared.postComment(movieId: movieId, rating: Double(self.starSlider.value), writer: writer, contents: contents) { result in
            if result == .failure {
                self.alertFunc(message: "한줄평 등록에 실패하였습니다")
                return
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
    private func alertFunc(message: String) {
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

 

}

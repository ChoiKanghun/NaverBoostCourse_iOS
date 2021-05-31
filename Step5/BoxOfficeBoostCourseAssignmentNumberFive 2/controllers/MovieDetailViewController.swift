//
//  MovieDetailViewController.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/06.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backNavigationItem: UINavigationItem!
    let imageAndMovieInfoCellIdentifier: String = "imageAndMovieInfoCell"
    let synopsisCellIdentifier: String = "synopsisCell"
    let actorsCellIdentifier: String = "actorsCell"
    let commentCellIdentifier: String = "commentCell"
    let postCommentCellIdentifier: String = "postCommentCell"
    
    var imageView = UIImageView()
    var isEnlarged: Bool = false
    
    var id: String?
    
    var details: Detail?
    var commments: [Comment] = []
    var newImageView: UIImageView = UIImageView()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: PostCommentViewController = segue.destination as? PostCommentViewController else {
            return
        }
        nextViewController.movieId = self.id
        nextViewController.titleToSet = self.details?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let movieId:String = self.id
            else {return}
        requestDetails(id: movieId)
        requestComments()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieDetailNotification(_:)) , name: DidReceiveMovieDetailNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveCommentsNotification(_:)), name: DidReceiveCommentsNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: DidDismissPostCommentViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    @objc func didDismissPostCommentNotification(_ noti: Notification) {
        requestComments()
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
            
    }
    
    @objc func didReceiveMovieDetailNotification(_ noti: Notification) {
        guard let details: Detail = noti.userInfo?["details"] as? Detail
            else {return}
        self.details = details
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @objc func didReceiveCommentsNotification(_ noti: Notification) {
        guard let comments: [Comment] = noti.userInfo?["comments"] as? [Comment]
            else {return}
        self.commments = comments
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        
        self.isEnlarged = true
        guard let image = self.imageView.image
        else {
            print("cant get imageView")
            return
        }
        self.newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
        self.isEnlarged = false
        
    }
    
    @objc func deviceRotated() {
        if self.isEnlarged == true {
            self.view.subviews.last?.removeFromSuperview()
            imageTapped(sender: UITapGestureRecognizer())
        }
    }
    
    @objc func dismissAndMakeFull() {
            self.view.subviews.last?.removeFromSuperview()
            guard let image = self.imageView.image
            else {
                print("cant get imageView")
                return
            }
            let newImageView = UIImageView(image: image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action:
                #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        } else if indexPath.section == 2 {
            return UITableView.automaticDimension
        } else if indexPath.section == 3 {
            return UITableView.automaticDimension
        } else if indexPath.section == 4 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let detail: Detail = self.details
            else {return UITableViewCell()}
        switch indexPath.section {
        case 0:
            guard let imageAndMovieInfoCell: ImageAndMovieInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.imageAndMovieInfoCellIdentifier)
                as? ImageAndMovieInfoTableViewCell
                else {return UITableViewCell()}

            imageAndMovieInfoCell.titleUILabel?.text = detail.title
            self.title = detail.title
            imageAndMovieInfoCell.openingDateUILabel?.text = detail.openingDate
            imageAndMovieInfoCell.genreUILabel?.text = detail.genre
            guard let duration = detail.duration
                else {return UITableViewCell()}
            imageAndMovieInfoCell.duartionUILabel?.text = "/" + String(duration) + "분"
            guard let ranking = detail.ranking
                else {return UITableViewCell()}
            guard let reservationRate = detail.reservationRate
                else {return UITableViewCell()}
            imageAndMovieInfoCell.rankingUILabel?.text = String(ranking) + "위  " + String(reservationRate) + "%"
            guard let rating = detail.rating
                else {return UITableViewCell()}
            imageAndMovieInfoCell.ratingUILabel?.text = String(rating)
            guard let audience = detail.audience
                else {return UITableViewCell()}
            imageAndMovieInfoCell.audienceUILabel?.text = String(audience) + "명"
            let ratingIntValue = Int(floor(rating))
            DispatchQueue.main.async {
                for i in 1...5 {
                    if let starImage = self.view.viewWithTag(i) as? UIImageView {
                        if i <= ratingIntValue / 2 {
                            starImage.image = UIImage(named: "ic_star_large_full")
                        } else if (2 * i - ratingIntValue) <= 1 {
                            starImage.image = UIImage(named: "ic_star_large_half")
                        } else {
                            starImage.image = UIImage(named: "ic_star_large")
                        }
                    }
                }
            }
            switch detail.ageLimit {
            case 0:
                guard let ageLimitImage = UIImage(named: "ic_allages")
                    else {return UITableViewCell()}
                Singleton.shared.ageLimitImageName = "ic_allages"
                imageAndMovieInfoCell.ageLimitImageView?.image = ageLimitImage
            case 12:
                guard let ageLimitImage = UIImage(named:"ic_12")
                    else {return UITableViewCell()}
                Singleton.shared.ageLimitImageName = "ic_12"
                imageAndMovieInfoCell.ageLimitImageView?.image = ageLimitImage
            case 15:
                guard let ageLimitImage = UIImage(named:"ic_15")
                    else {return UITableViewCell()}
                Singleton.shared.ageLimitImageName = "ic_15"
                imageAndMovieInfoCell.ageLimitImageView?.image = ageLimitImage
            case 19:
                guard let ageLimitImage = UIImage(named:"ic_19")
                    else {return UITableViewCell()}
                Singleton.shared.ageLimitImageName = "ic_19"
                imageAndMovieInfoCell.ageLimitImageView?.image = ageLimitImage
            default:
                return UITableViewCell()
            }
            
            DispatchQueue.global().async {
                guard let imageURL: URL = URL(string: detail.imageAddress!)
                    else {return}
                guard let imageData: Data = try? Data(contentsOf: imageURL)
                    else {return}
                DispatchQueue.main.async {
                    imageAndMovieInfoCell.detailImageView?.image = UIImage(data: imageData)
                    self.imageView.image = UIImage(data: imageData)
                    let frame = CGRect(x: 0, y: 0, width: 125, height: 125)
                    imageAndMovieInfoCell.detailImageView?.frame = frame
                }
            }
            return imageAndMovieInfoCell
            
        case 1:
            guard let synopsisCell: SynopsisTableViewCell
                = tableView.dequeueReusableCell(withIdentifier: self.synopsisCellIdentifier)
                    as? SynopsisTableViewCell
                else {return UITableViewCell()}
            synopsisCell.synopsisUILabel.numberOfLines = 0
            // 아래 줄 생략 불가.
            synopsisCell.synopsisUILabel.translatesAutoresizingMaskIntoConstraints = false
           // 아래 줄 생략 가능.
            synopsisCell.synopsisUILabel.lineBreakMode = .byWordWrapping
            synopsisCell.synopsisUILabel?.text = detail.synopsis
            NSLayoutConstraint.activate([
                synopsisCell.synopsisUILabel.topAnchor.constraint(equalTo: synopsisCell.layoutMarginsGuide.topAnchor, constant: 20),
                synopsisCell.synopsisUILabel.trailingAnchor.constraint(equalTo: synopsisCell.layoutMarginsGuide.trailingAnchor),
                synopsisCell.synopsisUILabel.leadingAnchor.constraint(equalTo: synopsisCell.layoutMarginsGuide.leadingAnchor)
            ])
            return synopsisCell
            
        case 2:
            guard let actorsCell: ActorsTableViewCell
                = tableView.dequeueReusableCell(withIdentifier: self.actorsCellIdentifier)
                as? ActorsTableViewCell
                else {return UITableViewCell()}
            actorsCell.directorUILabel?.text = detail.director
            actorsCell.charactersUILabel?.text = detail.actor
            actorsCell.directorUILabel.translatesAutoresizingMaskIntoConstraints = false
            actorsCell.charactersUILabel.translatesAutoresizingMaskIntoConstraints = false
            actorsCell.charactersUILabel.numberOfLines = 0
            actorsCell.charactersUILabel.lineBreakMode = .byWordWrapping
            let bounds = UIScreen.main.bounds
            let width = bounds.width
            actorsCell.charactersUILabel.preferredMaxLayoutWidth = width - 90
            NSLayoutConstraint.activate([
                actorsCell.directorUILabel.topAnchor.constraint(equalTo: actorsCell.layoutMarginsGuide.topAnchor, constant: 12.5),
                actorsCell.directorUILabel.leadingAnchor.constraint(equalTo: actorsCell.layoutMarginsGuide.leadingAnchor, constant: 54.5),
                actorsCell.charactersUILabel.topAnchor.constraint(equalTo: actorsCell.directorUILabel.bottomAnchor, constant: 5),
                actorsCell.charactersUILabel.leadingAnchor.constraint(equalTo: actorsCell.layoutMarginsGuide.leadingAnchor, constant: 54.5)
            ])
            return actorsCell
            
        case 3:
            guard let postCommentCell: PostButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.postCommentCellIdentifier) as? PostButtonTableViewCell
                else {return UITableViewCell()}
            return postCommentCell
            
        case 4:
            guard let commentCell: CommentTableViewCell
                       = tableView.dequeueReusableCell(withIdentifier: self.commentCellIdentifier)
                       as? CommentTableViewCell
                       else {return UITableViewCell()}
            let comment: Comment = self.commments[indexPath.row]
            commentCell.writerUILabel?.text = comment.writer
            commentCell.contentsUILabel?.text = comment.contents
            let formatter: DateFormatter = DateFormatter()
            //formatter.dateStyle = DateFormatter.Style.long
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            guard let timeStampRawValue: Double = comment.timestamp
                else {return UITableViewCell()}
            let commentDate: Date = Date(timeIntervalSince1970: timeStampRawValue)
            commentCell.timestampUILabel?.text = formatter.string(from: commentDate)
            
            guard let rating = comment.rating
                else {return UITableViewCell()}
            let ratingIntValue = Int(floor(rating))
            DispatchQueue.main.async {
                switch ratingIntValue {
                case 10:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFour.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFive.image = UIImage(named: "ic_star_large_full")
                case 9:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFour.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFive.image = UIImage(named: "ic_star_large_half")
                case 8:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFour.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                case 7:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFour.image = UIImage(named: "ic_star_large_half")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                case 6:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large_full")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                case 5:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large_half")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                case 4:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_full")
                        commentCell.starThree.image = UIImage(named: "ic_star_large")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                    
                case 3:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large_half")
                        commentCell.starThree.image = UIImage(named: "ic_star_large")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                case 2:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_full")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large")
                        commentCell.starThree.image = UIImage(named: "ic_star_large")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                case 1:
                        commentCell.starOne.image = UIImage(named: "ic_star_large_half")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large")
                        commentCell.starThree.image = UIImage(named: "ic_star_large")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                default:
                        commentCell.starOne.image = UIImage(named: "ic_star_large")
                        commentCell.starTwo.image = UIImage(named: "ic_star_large")
                        commentCell.starThree.image = UIImage(named: "ic_star_large")
                        commentCell.starFour.image = UIImage(named: "ic_star_large")
                        commentCell.starFive.image = UIImage(named: "ic_star_large")
                }
                
            }
            return commentCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4:
            return self.commments.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 4 {
            return 0.0
        }
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.zero)
        if section == 0 {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = .gray
        }
        return view
    }
}


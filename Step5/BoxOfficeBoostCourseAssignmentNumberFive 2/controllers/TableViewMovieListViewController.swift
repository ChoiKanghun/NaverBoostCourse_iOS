//
//  TableViewMovieListViewController.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/04.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class TableViewMovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "movieCell"
    
    var movies: [Movie] = []
    enum OrderTypeEnumeration: Int {
        case reservationRate = 0
        case curation
        case openingDate
    }
    var orderType: Int = OrderTypeEnumeration.reservationRate.rawValue
    
    enum OrderTypeString: String {
         case reservationRate = "예매율"
         case curation = "큐레이션"
         case openingDate = "개봉일"
     }
    var orderTypeString: String = OrderTypeString.reservationRate.rawValue
    
    var loadingImage = UIImageView()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    
    // MARK:- API 요청 및 가져오기
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestMovies(orderType: self.orderType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestMovies(orderType: self.orderType)
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "예매율순"
        
        self.orderType = 0
        Singleton.shared.orderType = self.orderType

        // set title
        Singleton.shared.tableViewTitleOrder = self.orderTypeString + "순"
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder

        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        self.loadingImage = UIImageView(image: UIImage(named: "refresh-256"))
        loadingImage.frame.size = CGSize(width: 60, height: 60)
        self.loadingImage.center.x = (self.refreshControl.frame.width) / 2 + 30
        self.refreshControl.addSubview(self.loadingImage)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func didReceiveMoviesNotification(_ noti: Notification) {
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie]
            else {return}
        self.movies = movies
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func touchUpShowSortActionSheetButton(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
      // style을 UIAcionSheet 스타일로 해달라 (두 개가 다임)
    }
    
    func showAlertController(style: UIAlertController.Style) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: style)
      // title, message 설정. style은 인자로 받은 UIAlertController.Style. alert or actionSheet
        
        let SortByReservationRateAction: UIAlertAction
        SortByReservationRateAction = UIAlertAction(title: OrderTypeString.reservationRate.rawValue, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            
            self.setOrderTypeAndTitle(orderType: 0, title: OrderTypeString.reservationRate.rawValue)
        })
        
        let sortByCurationAction = UIAlertAction(title: OrderTypeString.curation.rawValue, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.setOrderTypeAndTitle(orderType: 1, title: OrderTypeString.curation.rawValue)
        })
        
        let sortByOpeningDate = UIAlertAction(title: OrderTypeString.openingDate.rawValue, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.setOrderTypeAndTitle(orderType: 2, title: OrderTypeString.openingDate.rawValue)
        })
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
          // 핸들러가 nil인 경우 아무 액션 없이 그냥. dismiss됨
      
        
        alertController.addAction(SortByReservationRateAction)
        alertController.addAction(sortByCurationAction)
        alertController.addAction(sortByOpeningDate)
        alertController.addAction(cancelAction)
        
        self.present(alertController ,animated: true, completion: nil)
    }
    
    func setOrderTypeAndTitle (orderType: Int, title: String){
        // set orderType
        self.orderType = orderType
        Singleton.shared.orderType = self.orderType
        
        // set title
        let orderString: String = title
        requestMovies(orderType: self.orderType)
        Singleton.shared.tableViewTitleOrder = orderString + "순"
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController:MovieDetailViewController = segue.destination as? MovieDetailViewController
            else {return}
        guard let cell: MovieListCellTableViewCell = sender as? MovieListCellTableViewCell
            else {return}
        
        guard let id: String = cell.movieId
            else {return}
        nextViewController.id = id
    }
 

}

// MARK:- TableViewCell 뿌리는 지점
extension TableViewMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieListCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MovieListCellTableViewCell
            else {return UITableViewCell()}
        
        let movie: Movie = self.movies[indexPath.row]
        
        cell.movieTitle?.text = movie.title
        cell.movieRating?.text = "평점: " + String(movie.rating)
        cell.movieRanking?.text = "예매순위: " + String(movie.ranking)
        cell.movieReservationRate?.text = "예매율: " + String(movie.reservationRate) + "%"
        cell.movieOpeningDate?.text = "개봉일: " + movie.openingDate
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: movie.imageAddress)
                 else {return}
            guard let imageData: Data = try? Data(contentsOf: imageURL)
                 else {return}
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if (index.row == indexPath.row) {
                        cell.movieImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        var ageLimitImageName: String?
        switch movie.ageLimit {
        case 0:
            ageLimitImageName = "ic_alleages"
        case 12:
            ageLimitImageName = "ic_12"
        case 15:
            ageLimitImageName = "ic_15"
        case 19:
            ageLimitImageName = "ic_19"
        default:
            return UITableViewCell()
        }
        
        if let name = ageLimitImageName {
            let ageLimitImage = UIImage(named: name)
            cell.ageLimitImageView?.image = ageLimitImage
        } else {
            return UITableViewCell()
        }
        cell.movieId = movie.id
 
        return cell
    }
}

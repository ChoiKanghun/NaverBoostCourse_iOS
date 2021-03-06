//
//  TableViewMovieListViewController.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/04.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

let DidReceiveOrderTypeNotification = NSNotification.Name("orderTypeNotification")

class MovieListTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "movieCell"
    
    var movies: [Movie] = []

    var orderType: OrderType = OrderType.reservationRate

    private let refreshControl: UIRefreshControl = {
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
        
        if self.movies.count == 0 {
            RequestUtils.shared.requestMovies(orderType: orderType) { result in
                if result == .failure {
                    AlertUtil.justAlert(viewController: self,
                                        title: "에러",
                                        message: "네트워크 통신에 문제가 있습니다",
                                        preferredStyle: .alert)
                    return
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RequestUtils.shared.requestMovies(orderType: orderType) { result in
            if result == .failure {
                AlertUtil.justAlert(viewController: self,
                                    title: "에러",
                                    message: "네트워크 통신에 문제가 있습니다",
                                    preferredStyle: .alert)
            }
        }
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder
        DispatchQueue.main.async {
            self.handleRefresh(self.refreshControl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "예매율순"
        
        Singleton.shared.orderType = self.orderType

        // set title
        Singleton.shared.tableViewTitleOrder = self.orderType.description + "순"
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder

        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setOrderTypeAndTitleByNotification(_:)), name: DidReceiveOrderTypeNotification, object: nil)

        self.tableView.addSubview(self.refreshControl)
        RequestUtils.shared.requestMovies(orderType: orderType) { result in
            if result == .failure {
                AlertUtil.justAlert(viewController: self,
                                    title: "에러",
                                    message: "네트워크 통신에 문제가 있습니다",
                                    preferredStyle: .alert)
                return
            }
        }

    }
    
    @objc private func didReceiveMoviesNotification(_ noti: Notification) {
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
    
    private func showAlertController(style: UIAlertController.Style) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: style)
      // title, message 설정. style은 인자로 받은 UIAlertController.Style. alert or actionSheet
        
        let SortByReservationRateAction: UIAlertAction
        SortByReservationRateAction = UIAlertAction(title: OrderType.reservationRate.description, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            
            Utils.setOrderTypeAndTitle(orderType: 0, viewController: self)
        })
        
        let sortByCurationAction = UIAlertAction(title: OrderType.curation.description, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            Utils.setOrderTypeAndTitle(orderType: 1, viewController: self)
        })
        
        let sortByOpeningDate = UIAlertAction(title: OrderType.openingDate.description, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            Utils.setOrderTypeAndTitle(orderType: 2, viewController: self)
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
    

    
    @objc func setOrderTypeAndTitleByNotification(_ notification: Notification) {
        if let rawValue = notification.object as? Int,
           let orderType = OrderType(rawValue: rawValue) {
            self.orderType = orderType
            Singleton.shared.orderType = orderType
            
            RequestUtils.shared.requestMovies(orderType: orderType) { result in
                if result == .failure {
                    AlertUtil.justAlert(viewController: self,
                                        title: "에러",
                                        message: "네트워크 통신에 문제가 있습니다",
                                        preferredStyle: .alert)
                    return
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController:MovieDetailViewController = segue.destination as? MovieDetailViewController
            else {return}
        guard let cell: MovieTableViewCell = sender as? MovieTableViewCell
            else {return}
        
        guard let id: String = cell.movieId
        else {return}
        nextViewController.id = id
    }
 

}

// MARK:- TableViewCell 뿌리는 지점
extension MovieListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MovieTableViewCell
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
        if let ageLimitImage = UIImage(named: movie.getMovieImageName()) {
            cell.ageLimitImageView?.image = ageLimitImage
            cell.movieId = movie.id
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}

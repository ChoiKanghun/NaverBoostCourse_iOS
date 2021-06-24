//
//  CollectionViewMoiveListViewController.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/30.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class CollectionViewMoiveListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier: String = "collectionViewMovieCell"
    
    var movies: [Movie] = []

    var orderType: Int = 0
 
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        requestMovies(orderType: self.orderType)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        


        requestMovies(orderType: self.orderType)
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }
    
    private func getFlowLayout(isLandscape: Bool) -> UICollectionViewFlowLayout {
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        
        if (isLandscape == true) { // 가로
            flowLayout.itemSize = CGSize(width: halfWidth - 50, height: screenHeight * 1.2)
        }
        else { // 세로
            flowLayout.itemSize = CGSize(width: halfWidth - 20, height: screenHeight * 0.6)
        }
        
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.collectionViewLayout
            = getFlowLayout(isLandscape: UIDevice.current.orientation.isLandscape)
        
        if let orderType = Singleton.shared.orderType {
            self.orderType = orderType.rawValue
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)

        self.collectionView.addSubview(self.refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setOrderTypeAndTitleByNotification(_:)), name: DidReceiveOrderTypeNotification, object: nil)
    }

    @objc func deviceRotated() {
        if UIDevice.current.orientation.isLandscape {
            let flowLayout = getFlowLayout(isLandscape: true)
            let itemSize = flowLayout.itemSize

            guard let collectionViewLayout
                = self.collectionView?.collectionViewLayout
                as? UICollectionViewFlowLayout
            else {
                print("can't get collectionViewLayout")
                return
            }
            collectionViewLayout.itemSize = itemSize
            collectionViewLayout.invalidateLayout()
        }
        if UIDevice.current.orientation.isPortrait {
            let flowLayout = getFlowLayout(isLandscape: false)
            let itemSize = flowLayout.itemSize

            guard let collectionViewLayout
                = self.collectionView?.collectionViewLayout
                as? UICollectionViewFlowLayout
            else {
                print("can't get collectionViewLayout")
                return
            }
            collectionViewLayout.itemSize = itemSize
            collectionViewLayout.invalidateLayout()
        }
    }
    
    @objc func didReceiveMoviesNotification(_ noti: Notification) {
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie]
            else {return}
        self.movies = movies
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    private func setOrderTypeAndTitle (orderType: Int, title: String){
        // set orderType
        self.orderType = orderType
        Singleton.shared.orderType = OrderType(rawValue: self.orderType)
        
        // set title
        let orderString: String = title
        Singleton.shared.tableViewTitleOrder = orderString + "순"
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder
        NotificationCenter.default.post(name: DidReceiveOrderTypeNotification, object: orderType)
    }
    
    @objc func setOrderTypeAndTitleByNotification(_ notification: Notification) {
        if let orderType = notification.object as? Int {
            self.orderType = orderType
            Singleton.shared.orderType = OrderType(rawValue: self.orderType)
            
            requestMovies(orderType: orderType)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController
            else {return}
        guard let cell: MovieListCollectionViewCell = sender as? MovieListCollectionViewCell
            else {return}
        
        guard let id: String = cell.movieId else {return}
        nextViewController.id = id
    }
    
    
   
}



extension CollectionViewMoiveListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MovieListCollectionViewCell
            else {return UICollectionViewCell()}
        
        let movie: Movie = self.movies[indexPath.row]
        
        cell.titleLabel?.text = movie.title
        cell.averageRatingLabel?.text = String(movie.ranking) + "위(" + String(movie.rating) + ")" + " / " + String(movie.reservationRate) + "%"
        cell.openingDateLabel?.text = "개봉일: " + movie.openingDate
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: movie.imageAddress)
                else {return}
            guard let imageData: Data = try? Data(contentsOf: imageURL)
                else {return}
            DispatchQueue.main.async {
                cell.movieImageView?.image = UIImage(data: imageData)
            }
        }
        var ageLimitImage: UIImage?
        switch movie.ageLimit {
        case 0:
            ageLimitImage = UIImage(named: "ic_allages")
        case 12:
            ageLimitImage = UIImage(named: "ic_12")
        case 15:
            ageLimitImage = UIImage(named: "ic_15")
        case 19:
            ageLimitImage = UIImage(named: "ic_19")
        default:
            return UICollectionViewCell()
        }
        cell.ageLimitImageView?.image = ageLimitImage
        cell.movieId = movie.id
        
        return cell
    }
    
}

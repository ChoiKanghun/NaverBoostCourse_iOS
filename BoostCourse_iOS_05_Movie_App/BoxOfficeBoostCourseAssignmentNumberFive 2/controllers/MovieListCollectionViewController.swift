//
//  CollectionViewMoiveListViewController.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/30.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UIViewController {


    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier: String = "collectionViewMovieCell"
    
    var movies: [Movie] = []

    var orderType: OrderType = OrderType.reservationRate
 
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
        
        
        RequestUtils.shared.requestMovies(orderType: self.orderType) { result in
            if result == .failure {
                AlertUtil.justAlert(viewController: self,
                                    title: "에러",
                                    message: "네트워크 통신에 문제가 있습니다",
                                    preferredStyle: .alert)
                return
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        


        RequestUtils.shared.requestMovies(orderType: self.orderType) { result in
            if result == .failure {
                AlertUtil.justAlert(viewController: self,
                                    title: "에러",
                                    message: "네트워크 통신에 문제가 있습니다",
                                    preferredStyle: .alert)
                return
            }
        }
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
            self.orderType = orderType
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
        
 
        let sortByReservationRateAction: UIAlertAction
        sortByReservationRateAction = UIAlertAction(title: OrderType.reservationRate.description, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
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
      
        
        alertController.addAction(sortByReservationRateAction)
        alertController.addAction(sortByCurationAction)
        alertController.addAction(sortByOpeningDate)
        alertController.addAction(cancelAction)
        
        self.present(alertController ,animated: true, completion: nil)
    }
    
    @objc func setOrderTypeAndTitleByNotification(_ notification: Notification) {
        if let intValue = notification.object as? Int,
           let orderType = OrderType(rawValue: intValue) {
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



extension MovieListCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        if let ageLimitImage = UIImage(named: movie.getMovieImageName()) {
            cell.ageLimitImageView?.image = ageLimitImage
            cell.movieId = movie.id
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
}

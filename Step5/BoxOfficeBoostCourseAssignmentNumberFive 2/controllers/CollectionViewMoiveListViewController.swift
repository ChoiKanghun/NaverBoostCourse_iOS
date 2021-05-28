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
    
    var loadingImage = UIImageView()
    
    lazy var refreshControl: UIRefreshControl = {
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
        

        self.collectionView.collectionViewLayout = getFlowLayout()
        
        requestMovies(orderType: self.orderType)
        self.navigationItem.title = Singleton.shared.tableViewTitleOrder
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }
    
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        // section의 inset (섹션의 인셋)을 없애라.
        // 공식문서의 정의:The margins used to lay out content in a section.
        flowLayout.minimumLineSpacing = 10
        // 라인 간의 거리
        flowLayout.minimumInteritemSpacing = 10
        // 아이템 간의 거리
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        flowLayout.itemSize = CGSize(width: halfWidth - 10, height: screenHeight * 0.6)
        // 가로는 30 작게, 높이는 90정도로 하면 좋겠다.
        // estimated인 이유는 autoLayout을 지정했기 때문에
        // 내 예상 이 정도 될 것 같으니 알아서 잘 배치해봐라. 라는 뜻임.
        
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let orderType = Singleton.shared.orderType {
            self.orderType = orderType
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        self.loadingImage = UIImageView(image: UIImage(named: "refresh-256"))
        loadingImage.frame.size = CGSize(width: 60, height: 60)
        self.loadingImage.center.x = (self.refreshControl.frame.width) / 2 + 30
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }

    @objc func deviceRotated() {
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        }
        if UIDevice.current.orientation.isPortrait {
            print("portrait")
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
            self.collectionView.reloadData()
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
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            print("view will changed from landscape")
        }
        
        
//        let flowLayout = getFlowLayout()
//        let itemSize = flowLayout.itemSize
//
//        guard let collectionViewLayout
//            = self.collectionView?.collectionViewLayout
//            as? UICollectionViewFlowLayout
//        else {
//            print("can't get collectionViewLayout")
//            return
//        }
//        collectionViewLayout.itemSize = itemSize
//        collectionViewLayout.invalidateLayout()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        print("Will rotate")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("Will transition")
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

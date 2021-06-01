//
//  DetailViewController.swift
//  BoostCourseMyAlbumAsssignment
//
//  Created by 최강훈 on 2020/11/14.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController, UIScrollViewDelegate, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heartBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    var detailImage: UIImage!
    var detailAsset: PHAsset!
    var imageName: String?
    
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.imageName
        
        imageManager.requestImage(for: detailAsset, targetSize: CGSize(width: detailAsset.pixelWidth, height: detailAsset.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: { (image, _) in
            self.imageView?.image = image

            let favoriteName = self.detailAsset.isFavorite ? "heart.fill" : "heart"
            self.heartBarButtonItem.image = UIImage.init(systemName: favoriteName)
            PHPhotoLibrary.shared().register(self)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    @IBAction func checkAndChangeHeartBarButtonItem() {

        let isFavorite: Bool = !self.detailAsset.isFavorite
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.detailAsset)
            request.isFavorite = isFavorite
            print("status: \(self.detailAsset.isFavorite)")
        }, completionHandler: {(success, error) in
            if success {
                OperationQueue.main.addOperation {
                    let favoriteName = isFavorite ? "heart.fill" : "heart"
                    self.heartBarButtonItem.image = UIImage.init(systemName: favoriteName)
                }
            }
        })
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {

        guard let changes = changeInstance.changeDetails(for: self.detailAsset)
            else {return}
        self.detailAsset = changes.objectAfterChanges
        OperationQueue.main.addOperation {
            let isFavorite: Bool = self.detailAsset.isFavorite
            let favoriteName = isFavorite ? "heart.fill" : "heart"
            self.heartBarButtonItem.image = UIImage.init(systemName: favoriteName)
        }
    }
    
    // MARK: 네비게이션 바 공유 기능 버튼
    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
    
        let activityItem: [AnyObject] = [self.imageView.image as AnyObject]
        
        // UIActivityViewController를 통해 공유 기능을 구현
        let activityViewController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: 네비게이션 바 삭제 기능 버튼
    @IBAction func trashButtonAction(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([self.detailAsset!] as NSArray)}, completionHandler: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // imageView 줌 기능
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    @IBAction func touchUpGestureRecognizer(_ sender: Any?) {
        navigationController?.isNavigationBarHidden = !navigationController!.isNavigationBarHidden
        navigationController?.setToolbarHidden(!navigationController!.isToolbarHidden, animated: true)
        if navigationController?.isNavigationBarHidden == true {
            self.view.backgroundColor = .black
        } else {
            self.view.backgroundColor = .white
        }
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        navigationController?.isNavigationBarHidden = !navigationController!.isNavigationBarHidden
        navigationController?.setToolbarHidden(!navigationController!.isToolbarHidden, animated: true)
        if navigationController?.isNavigationBarHidden == true {
            self.view.backgroundColor = .black
        } else {
            self.view.backgroundColor = .white
        }
    }
}

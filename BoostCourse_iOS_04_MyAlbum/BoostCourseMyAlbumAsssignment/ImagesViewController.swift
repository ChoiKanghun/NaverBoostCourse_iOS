//
//  ImagesViewController.swift
//  BoostCourseMyAlbumAsssignment
//
//  Created by 최강훈 on 2020/11/13.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit
import Photos

class ImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var sharingBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var sortBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var trashBarButtonItem: UIBarButtonItem!
    
    var images: PHFetchResult<PHAsset>!
    var albumName: String?
    var albumIndex: Int!
    
    let cellIdentifier: String = "imageViewCell"
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let half: Double = Double(UIScreen.main.bounds.width / 3.0 - 15)
    
    // 네비게이션 바 여러 개 선택하는 버튼
    var multiSelectionButtonItem: UIBarButtonItem!
    // 시간순 정렬(최신순은 false)
    var sortCheck: Bool = true
    // imageCell 터치 시 show되는 것을 방지.
    var selectCheck: Bool = false
    // 선택한 이미지의 인덱스
    var indexOfSelectedImage = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: half, height: half)
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0
        self.imageCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        self.navigationItem.title = albumName
        // 큰 타이틀 사용하지 않도록.
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        // 포토 라이브러리에 변화가 있는 경우 변경 사항을 적용하기 위해.
        PHPhotoLibrary.shared().register(self)
    
        // 네비게이션 바의 선택 버튼에 multiselectAction 함수 등록
        multiSelectionButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(multiselectAction(_:)))
        
        self.navigationItem.rightBarButtonItem = multiSelectionButtonItem
        
        sortBarButtonAction(self.sortBarButtonItem)
        multiselectAction(multiSelectionButtonItem)
        cancelAction(multiSelectionButtonItem)
    }
    
    // MARK: BarButtonItem 관련 함수들
    
    @objc func multiselectAction(_ sender: UIBarButtonItem) -> Void {
        self.selectCheck = true
        self.sharingBarButtonItem.isEnabled = true
        self.trashBarButtonItem.isEnabled = true
        self.navigationItem.title = "항목 선택"
        self.navigationItem.hidesBackButton = true
        
        // 선택 취소 함수를 동일 버튼에 등록
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction(_:)))

        self.imageCollectionView.allowsMultipleSelection = true
    }

    @objc func cancelAction(_ sender: UIBarButtonItem) -> Void {
        self.selectCheck = false
        self.sharingBarButtonItem.isEnabled = false
        self.trashBarButtonItem.isEnabled = false
        self.navigationItem.title = "선택"
        self.navigationItem.hidesBackButton = false
        self.navigationItem.rightBarButtonItem = multiSelectionButtonItem
        
        self.imageCollectionView.allowsMultipleSelection = false
        indexOfSelectedImage.removeAll()
        self.navigationItem.title = albumName
        self.imageCollectionView.reloadData()
    }

    //MARK: 공유 기능 버튼에 등록할 함수
    @IBAction func shareBarButtonAction(_ sender: UIBarButtonItem) {
        var asset = PHAsset()
        var image: UIImage
        var selectedImages: [UIImage] = []
        for i in indexOfSelectedImage {
            asset = images[i]
            image = getImageFromPHAsset(asset: asset)
            selectedImages.append(image)
        }
        
        guard selectedImages.count > 0
            else {return}
        
        // UIActivityViewController를 통한 shareAction 구현
        let activityViewController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    // shareAction을 위해 PHAsset->image로 변환함.
    func getImageFromPHAsset(asset: PHAsset) -> UIImage {
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
            image = result!
        })
        return image
    }
    
    //MARK: 정렬 버튼에 등록할 함수
    @IBAction func sortBarButtonAction(_ sender: UIBarButtonItem) {
        sortCheck = !sortCheck
        
        if !sortCheck { // !sortCheck는 현재 최신순이라는 뜻
            sortBarButtonItem.title = "최신순"
            let reversedDateOrderFetchOptions = PHFetchOptions()
            reversedDateOrderFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            if albumName == "Camera Roll" {
                let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                guard let album: PHAssetCollection = cameraRoll.firstObject
                    else {return}
                images = PHAsset.fetchAssets(in: album, options: reversedDateOrderFetchOptions)
            }
            else {
                let nameOrderFetchOptions = PHFetchOptions()
                nameOrderFetchOptions.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
                
                let albumList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nameOrderFetchOptions)
                
                let album: PHAssetCollection = albumList.object(at: albumIndex - 1)
                images = PHAsset.fetchAssets(in: album, options: reversedDateOrderFetchOptions)
            }
        }
        else {
            sortBarButtonItem.title = "과거순"
            let dateOrderFetchOptions = PHFetchOptions()
            dateOrderFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            if albumName == "Camera Roll" {
                let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                guard let album: PHAssetCollection = cameraRoll.firstObject
                    else {return}
                images = PHAsset.fetchAssets(in: album, options: dateOrderFetchOptions)
            }
            else {
                let nameOrderFetchOptions = PHFetchOptions()
                nameOrderFetchOptions.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
                
                let albumList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nameOrderFetchOptions)
                
                let album: PHAssetCollection = albumList.object(at: albumIndex - 1)
                images = PHAsset.fetchAssets(in: album, options: dateOrderFetchOptions)
                 
            }
        }
        imageCollectionView.reloadData()
    }
    
    // MARK: 네비게이션 바 내의 삭제 버튼에 등록할 함수
    @IBAction func trashBarButtonAction(_ sender: UIBarButtonItem) {
        var asset = [PHAsset]()
        
        for i in indexOfSelectedImage {
            asset.append(images[i])
        }
        
        //삭제 확인을 묻는 창 띄우기
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(asset as NSArray)}, completionHandler: nil)
        // 삭제 이후 네비게이션 바 아이템을 초기화함.
        self.sharingBarButtonItem.isEnabled = false
        self.trashBarButtonItem.isEnabled = false
        self.navigationItem.hidesBackButton = false
        self.navigationItem.rightBarButtonItem = multiSelectionButtonItem
        self.imageCollectionView.allowsMultipleSelection = false
        self.imageCollectionView.reloadData()
    }
    
    // MARK: numberOfItems
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    // MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? ImagesCollectionViewCell
            else {return UICollectionViewCell()}
 
        let image: PHAsset = images.object(at: indexPath.item)
        
        imageManager.requestImage(for: image, targetSize: CGSize(width: half, height: half), contentMode: .aspectFit, options: nil, resultHandler: {(image, _) in
            cell.imageView?.image = image
        })
        return cell
    }
    
    // MARK: didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !selectCheck {
            guard let nextController = storyboard?.instantiateViewController(identifier: "toDetail")
                else {return}
            guard let detailView: DetailViewController = nextController as? DetailViewController
                else {return}
            guard let cell: ImagesCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ImagesCollectionViewCell
                else {return}
            
            // 디테일 이미지의 타이틀이 될 시간 정보 설정.
            let formatter: DateFormatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            detailView.imageName = formatter.string(from: (images[indexPath.item].creationDate!))
            
            // 디테일 이미지의 정보 입력.
            detailView.detailImage = cell.imageView.image
            detailView.detailAsset = images[indexPath.item]
            navigationItem.title = self.albumName
            self.navigationController?.pushViewController(nextController, animated: true)
        } else {
            if !indexOfSelectedImage.contains(indexPath.item) {
                indexOfSelectedImage.append(indexPath.item)
            }
        }
        // 아래 코드는 선택한 사진들을 투명하게 만듦.
        if indexOfSelectedImage.count != 0 {
            collectionView.cellForItem(at: indexPath)?.alpha = 0.5
            navigationItem.title = String(indexOfSelectedImage.count) + "장 선택"
        }
    }
    
    // MARK: DidDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if !indexOfSelectedImage.isEmpty {
            guard let index: Int = indexOfSelectedImage.firstIndex(of: indexPath.item)
                else {return}
            indexOfSelectedImage.remove(at: index)
        }
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: images)
            else {return}
        images = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation {
            self.imageCollectionView.reloadData()
        }
    }
    
}

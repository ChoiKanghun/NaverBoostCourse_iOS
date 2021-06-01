//
//  AlbumListViewController.swift
//  BoostCourseMyAlbumAsssignment
//
//  Created by 최강훈 on 2020/11/02.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mainImageListCollectionView: UICollectionView!
    
    let cellIdentifier: String = "albumCell"
    
    var albumAssetList: [PHFetchResult<PHAsset>] = [PHFetchResult<PHAsset>]()
    var albumAssetNameList: [String] = [String]()
    var albumAssetCountList: [Int] = [Int]()
    
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let half: Double = Double(UIScreen.main.bounds.width / 2.0 - 10)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumAssetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumListCustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCustomCollectionViewCell
            else {return UICollectionViewCell()}
        
        /*
         PHAsset : 개별적인 사진 또는 비디오를 나타내는 타입으로, 해당 타입의 인스턴스로 실제 사진 이나 비디오를 요청하게 됩니다.
         `at: 0` 이 의미하는 것은 해당 앨범의 첫 번째 사진을 가져오라는 뜻이다.
         */
        let asset: PHAsset = albumAssetList[indexPath.item].object(at: 0)

        cell.albumNameLabel.text = albumAssetNameList[indexPath.item]
        cell.countOfPicturesInAlbumLabel.text = String(albumAssetCountList[indexPath.item])
        imageManager.requestImage(for: asset, targetSize: CGSize(width: half, height: half), contentMode: .aspectFill, options: nil, resultHandler: {(imageFromAsset, _) in
            cell.representativeImageView?.image = imageFromAsset
        })
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 스크롤을 하는 동안 타이틀을 계속 표시해주기 위해 사용.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject
            else {return}
        
        // 앨범을 정렬합니다.
        let fetchOptionsInTimeOrder = PHFetchOptions()
        fetchOptionsInTimeOrder.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
        let fetchOptionsInNameOrder = PHFetchOptions()
        fetchOptionsInNameOrder.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
        
        albumAssetList.append(PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptionsInTimeOrder))
        albumAssetNameList.append("Camera Roll")
        albumAssetCountList.append(albumAssetList[0].count)

        let albumCollection: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptionsInNameOrder)
        let albumCount = albumCollection.count
        let albumArray: [PHAssetCollection] = albumCollection.objects(at: IndexSet(0..<albumCount))
        // 앨범별로 분류해서 저장합니다.
        for i in 0..<albumCount {
            albumAssetList.append(PHAsset.fetchAssets(in: albumArray[i], options: fetchOptionsInTimeOrder))
            albumAssetCountList.append(albumAssetList[i+1].count)
            albumAssetNameList.append(albumArray[i].localizedTitle!)
            print("\(i)번째 앨범 \(albumCollection[i].localizedTitle!)의 사진 개수는 \(albumAssetList[i+1].count) 개")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "앨범"
        self.mainImageListCollectionView.delegate = self
        self.mainImageListCollectionView.dataSource = self
        // 사진 접근을 요청합니다.
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("포토라이브러리로의 접근을 허가했음")
            self.requestCollection()
            self.mainImageListCollectionView.reloadData()
        case .denied:
            print("접근이 허가되지 않음.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({(status) in
                switch status {
                case .authorized:
                    print("포토라이브러리로의 접근을 허가했음")
                    self.requestCollection()
                    
                    OperationQueue.main.addOperation {
                        self.mainImageListCollectionView.reloadData()
                    }
                case .denied:
                    print("접근이 불허됨")
                default:
                    break
                }
            })
        case .restricted:
            print("접근이 제한됨")
        default:
            print("default에 닿음")
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        
        // 섹션의 top left right bottom 을 0으로
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.itemSize = CGSize(width: half, height: half)
        
        self.mainImageListCollectionView.collectionViewLayout = flowLayout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextController: ImagesViewController = segue.destination as? ImagesViewController
            else {return}
        
        guard let cell: AlbumListCustomCollectionViewCell = sender as? AlbumListCustomCollectionViewCell
            else {return}
        
        guard let index: IndexPath = self.mainImageListCollectionView.indexPath(for: cell)
            else {return}
        
        nextController.images = albumAssetList[index.item]
        nextController.albumName = self.albumAssetNameList[index.item]
        nextController.albumIndex = index.item
    }
}

//
//  AlbumDetailImagesViewController.swift
//  BoostCourseMyAlbumAsssignment
//
//  Created by 최강훈 on 2020/11/09.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit
import Photos

class AlbumDetailImagesViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumListCustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? AlbumListCustomCollectionViewCell
            else {return UICollectionViewCell()}
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFill, options: nil, resultHandler: {(image, _) in
            cell.representativeImageView?.image = image
        })
        
        return cell
    }

    var fetchResult: PHFetchResult<PHAsset>!
    let cellIdentifier: String = "ImagesInAlbum"
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var assetCollection: PHAssetCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // 포토 가져와서 올리기
    
}

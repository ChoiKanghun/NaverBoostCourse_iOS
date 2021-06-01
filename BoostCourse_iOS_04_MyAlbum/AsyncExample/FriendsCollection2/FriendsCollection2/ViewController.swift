//
//  ViewController.swift
//  FriendsCollection2
//
//  Created by 최강훈 on 2020/10/31.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var friends: [Friend] = []
    let cellIdentifier: String = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friends.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FriendCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? FriendCollectionViewCell
            else {return UICollectionViewCell()}
        
        let friend: Friend = self.friends[indexPath.item]
        
        cell.nameAgeLabel.text = friend.nameAndAge
        cell.addressLabel.text = friend.fullAddress
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        // section의 inset (섹션의 인셋)을 없애라.
        // 인셋이 뭔지 모르면 검색!
        flowLayout.minimumLineSpacing = 10
        // 라인 간의 거리
        flowLayout.minimumInteritemSpacing = 10
        // 아이템 간의 거리
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        
        flowLayout.estimatedItemSize = CGSize(width: halfWidth - 30, height: 90)
        // 가로는 30 작게, 높이는 90정도로 하면 좋겠다.
        // estimated인 이유는 autoLayout을 지정했기 때문에
        // 내 예상 이 정도 될 것 같으니 알아서 잘 배치해봐라. 라는 뜻임.
        self.collectionView.collectionViewLayout = flowLayout
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "friends")
            else {return}
        
        do {
            self.friends = try jsonDecoder.decode([Friend].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.collectionView.reloadData()
    }


}


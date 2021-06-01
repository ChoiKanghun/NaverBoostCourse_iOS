//
//  ViewController.swift
//  Networking2
//
//  Created by 최강훈 on 2020/12/03.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "friendCell"
    var friends: [Friend] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let friend: Friend = self.friends[indexPath.row]
        
        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: friend.picture.medium)
                else {return }
            guard let imageData: Data = try? Data(contentsOf: imageURL)
                else {return }
            
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    
    @objc func didReceiveFriendsNotification(_ noti: Notification) {
        guard let friends: [Friend] = noti.userInfo?["friends"] as? [Friend]
            else {return}
        self.friends = friends
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestFriends()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveFriendsNotification(_:)), name: DidReceiveFriendsNotification, object: nil)
        /* 파라미터 설명
            self - 어떤 노티피케이션을 받을 건지.
            selector - 어떤 메서드를 통해서?
            name - DidReceiveFriendsnotification이라는 이름을 가진 것을 받아오겠다.
         */
    }

    

}


//
//  ViewController.swift
//  MyFriends2
//
//  Created by 최강훈 on 2020/10/18.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    let cellIdentifier: String = "cell"
    
    var friends: [Friend] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let friend: Friend = self.friends[indexPath.row]
        cell.textLabel?.text = friend.nameAndAge
        cell.detailTextLabel?.text = friend.fullAddress
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // self.tableView.dataSource = self
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "friends") else {
            return
        }
        do {
             self.friends = try jsonDecoder.decode([Friend].self, from: dataAsset.data)
            // 첫 번째 인자는 타입, 두 번째는 출처.
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData() // 마지막으로 리로드까지.

        
    }
    
    
    


}


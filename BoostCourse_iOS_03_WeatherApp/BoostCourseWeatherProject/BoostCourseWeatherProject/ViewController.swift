//
//  ViewController.swift
//  BoostCourseWeatherProject
//
//  Created by 최강훈 on 2020/10/19.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 넘겨받아야 할 것 - nation.country, nation.abbr
    
    
    // MARK: -Properties
        
    @IBOutlet weak var tableView: UITableView!
    let nationCellIdentifier = "nationCell"
    var nations: [Nation] = []
    
    
    // MARK:- viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "세계 날씨"
        
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "countries") else {
            return
        }
        
        do {
            self.nations = try jsonDecoder.decode([Nation].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
        
    }
    
    // MARK:- numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nations.count
    }

    
    // MARK:- cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nationCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.nationCellIdentifier, for: indexPath)
        
        // 나라이름
        let nationText: String = nations[indexPath.row].country
        // 나라이름 Label로 세팅
        nationCell.textLabel?.text = nationText
        
        // 국기이미지 이름
        let nationFlagImageName: String = "flag_" + nations[indexPath.row].abbr
        
        // 국가 약자를 accessibilityIdentifier에 담아 보내기 위해 set.
        nationCell.accessibilityIdentifier = nations[indexPath.row].abbr
        
        // 국기 이미지 세팅
        nationCell.imageView?.image = UIImage(named: nationFlagImageName)
        
        return nationCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // nextViewController의 destination이 CityListViewController가 아니면 return
        guard let nextViewController: CityListViewController = segue.destination as? CityListViewController else {
                return
        }
        
        //nextViewController로 정보를 보내는 것은 UITableViewCell임을 보장.
        guard let cell: UITableViewCell = sender as? UITableViewCell
        else {
            return
        }

        // nextViewController에 country이름인 textLabel과 abbr을 담아서 보냄.
        nextViewController.countryName = cell.textLabel?.text
        nextViewController.nationAbbr = cell.accessibilityIdentifier
        cell.isSelected = false
    }



}


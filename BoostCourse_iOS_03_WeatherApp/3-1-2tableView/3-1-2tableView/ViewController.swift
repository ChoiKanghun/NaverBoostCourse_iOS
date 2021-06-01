//
//  ViewController.swift
//  3-1-2tableView
//
//  Created by 최강훈 on 2020/10/18.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    let korean: [String] = ["가", "나", "다", "라", "마", "바", "사", "아", "자", "차"]
    let english: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    
    //MARK:- numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return korean.count
        case 1:
            return english.count
        case 2:
            return dates.count
        default:
            return 0
        }
    }
    
    //MARK:- cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section < 2 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            
            let text: String = indexPath.section == 0 ? korean[indexPath.row] : english[indexPath.row]
            
            cell.textLabel?.text  = text

            return cell
        } else { // 3번째 섹션
            let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.customCellIdentifier, for: indexPath) as! CustomTableViewCell
            /* as! CustomTableViewCell을 해주는 이유는 tableView.~ 부터
             as! 전까지가 일반 tableView를 위한 메서드이기 때문이다.
             이를 타입캐스팅해주는 부분이 as! 이하다.
             강제캐스팅하지 않는 방법도 있다. 이에 대해 연구해봐야.
            */
            cell.leftLabel?.text = self.dateFormatter.string(from: self.dates[indexPath.row])
            cell.rightLabel?.text = self.timeFormatter.string(from: self.dates[indexPath.row])
            
            return cell
        }
     }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < 2 {
            return section == 0 ? "한글" : "영어"
        }
        return nil // section이 2인 경우 타이틀을 없앰.
    }
    
    // MARK:- button interaction
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        dates.append(Date())
        self.tableView.reloadSections(IndexSet(2...2), with: UITableView.RowAnimation.automatic)
    }
    var dates: [Date] = []
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    //MARK:- custom Cell
    let customCellIdentifier: String = "customCell"
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           guard let nextViewController: SecondViewController = segue.destination as? SecondViewController else {
               return
           }
           
           guard let cell: UITableViewCell = sender as? UITableViewCell else {
               return
               // 화면전환을 위해 선택해야 하는 것은 tableViewCell이므로.
           }
           
           nextViewController.textToSet = cell.textLabel?.text
       }

    
}


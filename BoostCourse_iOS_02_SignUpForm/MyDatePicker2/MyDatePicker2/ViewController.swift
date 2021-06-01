//
//  ViewController.swift
//  MyDatePicker2
//
//  Created by 최강훈 on 2020/10/11.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        
        return formatter
    }()
    
    @IBAction func didDatePickerValueChanged(_ sender: UIDatePicker) {

        
        let date: Date = sender.date
        // 위는 다음과 같다.
        // let date: Date = self.datePicker.date
        let dateString: String = self.dateFormatter.string(from: date)
        
        self.dateLabel.text = dateString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


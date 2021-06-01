//
//  SecondViewController.swift
//  3-1-2tableView
//
//  Created by 최강훈 on 2020/10/18.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var textToSet: String?
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textLabel.text = self.textToSet
    }

   

}

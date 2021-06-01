//
//  SecondViewController.swift
//  3-1SimpleTable
//
//  Created by 최강훈 on 2020/10/17.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var textToSet: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textLabel.text = self.textToSet
        
    }
    @IBOutlet weak var textLabel: UILabel!
    
}

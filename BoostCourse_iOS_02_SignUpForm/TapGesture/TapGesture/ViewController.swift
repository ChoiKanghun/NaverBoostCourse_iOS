//
//  ViewController.swift
//  TapGesture
//
//  Created by 최강훈 on 2020/09/12.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true) // 강제 종료
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate  =  self
        self.view.addGestureRecognizer(tapGesture)
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }

}


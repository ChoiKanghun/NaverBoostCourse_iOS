//
//  ViewController.swift
//  Alert2
//
//  Created by 최강훈 on 2020/12/03.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func touchUpShowAlertButton(_ sender: UIButton) {
        self.showAlertController(style: UIAlertController.Style.alert)
    }
    
    @IBAction func touchUpShowActionSheetButton(_ sender: UIButton) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
    }
    
    func showAlertController(style: UIAlertController.Style) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "this is title", message: "this is message", preferredStyle: style)
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK Action", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction ) in
            print("OK button Pressed")
        })
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        let handler: (UIAlertAction) -> Void
        handler = { (action: UIAlertAction ) in
            print("\(action.title ?? "") action pressed")
        }
        
        let someAction: UIAlertAction
        someAction = UIAlertAction(title: "Some", style: UIAlertAction.Style.destructive, handler: handler)
        
        let anotherAction: UIAlertAction
        anotherAction = UIAlertAction(title: "Another", style: UIAlertAction.Style.destructive, handler: handler)
        
        alertController.addAction(someAction)
        alertController.addAction(anotherAction)
            
        self.present(alertController ,animated: true, completion: {
            print("Alert controller has been shown")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


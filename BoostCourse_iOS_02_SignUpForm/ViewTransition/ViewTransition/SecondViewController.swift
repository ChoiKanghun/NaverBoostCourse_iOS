//
//  SecondViewController.swift
//  ViewTransition
//
//  Created by 최강훈 on 2020/10/11.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

  

    // MARK: - Pop to previous view in Navigation stack system
    @IBAction func popToPreviousView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nameLabel.text = UserInformation.shared.name
        self.ageLabel.text = UserInformation.shared.age
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//
//  ViewController.swift
//  AsyncExample2
//
//  Created by 최강훈 on 2020/10/31.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func touchUpDownloadButton(_ sender: UIButton) {
        guard let imageURL: URL = URL(string: "https://cdn.pixabay.com/photo/2019/12/12/07/01/beomeosa-temple-4689959_1280.jpg")
            else {return}
        do {
            let imageData: Data = try Data.init(contentsOf: imageURL)
            guard let image: UIImage = UIImage(data: imageData)
                else {return}
            
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
        catch {
            return
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


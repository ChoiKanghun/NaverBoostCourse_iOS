//
//  ViewController.swift
//  AsyncExample
//
//  Created by 최강훈 on 2020/10/29.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func toudchUpDownloadButton(_ sender: UIButton) {
        // 이미지 다운로드 -> 이미지 뷰에 세팅
        //
        
        let imageURL: URL = URL(string: "https://cdn.pixabay.com/photo/2020/02/15/22/55/couple-4852225_1280.jpg")!

        OperationQueue().addOperation {
            let imageData: Data = try! Data.init(contentsOf: imageURL)
            let image: UIImage = UIImage(data: imageData)!
            
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


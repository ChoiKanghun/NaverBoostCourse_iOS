//
//  WeatherDetailViewController.swift
//  BoostCourseWeatherProject
//
//  Created by 최강훈 on 2020/10/20.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // temperatureLabel text & color setting
        self.temperatureLabel?.text = self.textForTemperatureLabel
        self.temperatureLabel?.textColor = self.colorForTemperatureLabel

        // rainProbabilityLabel text & color setting
        self.rainProbabilityLabel?.text = self.textForRainProbabilityLabel
        self.rainProbabilityLabel?.textColor = self.colorForRainProbabilityLael
        
        // weatherImageViewImage and Weather state in korean setting
        self.weatherImageView.image = self.imageForWeatherImageView
        self.weatherLabel?.text = getStateTextOfKorean(self.numberOfWeatherState!)
    }
    
    var textForTemperatureLabel: String?
    var textForRainProbabilityLabel: String?
    var imageForWeatherImageView: UIImage?
    var numberOfWeatherState: String?
    
    var colorForTemperatureLabel: UIColor?
    var colorForRainProbabilityLael: UIColor?
    
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainProbabilityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func getStateTextOfKorean(_ state: String) -> String {
        switch state {
        case "10":
            return "맑음"
        case "11":
            return "구름"
        case "12":
            return "비"
        case "13":
            return "눈"
        default:
            return "맑음"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CityListViewController.swift
//  BoostCourseWeatherProject
//
//  Created by 최강훈 on 2020/10/19.
//  Copyright © 2020 최강훈. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: -Properties
           
    @IBOutlet weak var cityListTableView: UITableView!
    let cityCellIdentifier = "cityCell"
    var countryName: String?
    var nationAbbr: String?
    var cities: [City] = []

    // MARK:- viewDidLoad
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cityListTableView.delegate = self
        self.cityListTableView.dataSource = self
        self.navigationItem.title = self.countryName
        
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: self.nationAbbr!) else {
               return
        }
           
        do {
            self.cities = try jsonDecoder.decode([City].self, from: dataAsset.data)
        } catch {
               print(error.localizedDescription)
        }
           
        self.cityListTableView.reloadData()
           
    }
       
       // MARK:- numberOfRowsInSection
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return cities.count
       }

    
       
       // MARK:- cellForRowAt
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cityCell: CityInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cityCellIdentifier, for: indexPath) as! CityInfoTableViewCell
        
           
        // set cityCell city's label
        let cityText: String = cities[indexPath.row].cityName
        cityCell.cityNameLabel?.text = cityText
        
        // set cityCell temperature label & color of label
        let temperatureText: String = cities[indexPath.row].degree
        cityCell.tempInLabel?.text = temperatureText
        if (cities[indexPath.row].celsius >= 25) {
            cityCell.tempInLabel?.textColor = .red
        }
        if (cities[indexPath.row].celsius <= 10) {
            cityCell.tempInLabel?.textColor = .blue
        }
        
        // rainfallProbability label & color set
        let rainProbability: Int = Int(cities[indexPath.row].rainfallProbability)
        cityCell.rainProbabilityLabel?.text = "강수확률 " + String(rainProbability) + "%"
        if rainProbability >= 50 {
            cityCell.rainProbabilityLabel?.textColor = .orange
        }
        
        // MARK:- Research for passing data secretly needs to be done.
        // to pass the weather images' state number
        cityCell.accessibilityIdentifier = String(cities[indexPath.row].state)
        
        // get state and set weather image
        let weatherImageName: String = getStateText(cities[indexPath.row].state)
        cityCell.weatherImage?.image = UIImage(named: weatherImageName)
        
        return cityCell
    }
    
 
    // MARK:- Height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    // MARK:- getting the string by state number
    func getStateText(_ state: Int) -> String {
        switch state {
        case 10:
            return "sunny"
        case 11:
            return "cloudy"
        case 12:
            return "rainy"
        case 13:
            return "snowy"
        default:
            return "sunny"
        }
    }
       
    // MARK:- pass information to next viewController

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // nextViewController의 destination이 CityListViewController가 아니면 return
        guard let nextViewController: WeatherDetailViewController = segue.destination as? WeatherDetailViewController else {
                return
        }
        
        //nextViewController로 정보를 보내는 것은 UITableViewCell임을 보장.
        guard let cell: CityInfoTableViewCell = sender as? CityInfoTableViewCell
        else {
            return
        }

        // nextViewController에 country이름인 textLabel과 abbr을 담아서 보냄.
        nextViewController.textForTemperatureLabel = cell.tempInLabel?.text
        nextViewController.textForRainProbabilityLabel = cell.rainProbabilityLabel?.text
        nextViewController.imageForWeatherImageView = cell.weatherImage?.image
        nextViewController.numberOfWeatherState = cell.accessibilityIdentifier
        
        // pass color info
        nextViewController.colorForTemperatureLabel = cell.tempInLabel?.textColor
        nextViewController.colorForRainProbabilityLael = cell.rainProbabilityLabel?.textColor
        
        // following line is to set the state unclicked
        cell.isSelected = false
    }

}

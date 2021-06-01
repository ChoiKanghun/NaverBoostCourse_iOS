//
//  Nation.swift
//  BoostCourseWeatherProject
//
//  Created by 최강훈 on 2020/10/19.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

/*
{
 {"korean_name":"한국","asset_name":"kr"},
 {"korean_name":"독일","asset_name":"de"},
 {"korean_name":"이탈리아","asset_name":"it"},
 {"korean_name":"미국","asset_name":"us"},
 {"korean_name":"프랑스","asset_name":"fr"},
 {"korean_name":"일본","asset_name":"jp"}
}
*/

struct Nation: Codable {
    let country: String
    let abbr: String
    
    enum CodingKeys: String, CodingKey {
        case country = "korean_name"
        case abbr = "asset_name"
    }
}

/*
 {
    "city_name":"세종",
    "state":13,
    "celsius":24.8,
    "rainfall_probability":60
 },
 {
    "city_name":"청주",
    "state":11,
    "celsius":14.5,
    "rainfall_probability":80
 },
 */

struct City: Codable {
    let cityName: String
    let state: Int
    let celsius: Double
    let rainfallProbability: Double
    
    var fahrenheit: Double {
        return round((self.celsius * 1.8 + 32) * 10) / 10
    }
    
    var degree: String {
        return "섭씨 \(self.celsius)도 / 화씨 \(self.fahrenheit)도"
    }
    
    
    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case rainfallProbability = "rainfall_probability"
        case state, celsius
    }
}

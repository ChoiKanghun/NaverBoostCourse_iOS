//
//  RequestMovies.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/05.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

let DidReceiveMoviesNotification: Notification.Name
    = Notification.Name("DidReceiveMovies")

func requestMovies(orderType: OrderType) {
    guard let apiURL: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movies?order_type=" + String(orderType.rawValue))
        else {return}
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print (error.localizedDescription)
            return
        }
        guard let data = data
            else {return}
        
        do {
            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": apiResponse.movies])
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}

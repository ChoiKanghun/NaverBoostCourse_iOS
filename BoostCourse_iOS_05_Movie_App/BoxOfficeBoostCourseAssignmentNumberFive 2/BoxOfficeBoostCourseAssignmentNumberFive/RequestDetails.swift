//
//  RequestDetails.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/14.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

let DidReceiveMovieDetailNotification: Notification.Name
    = Notification.Name("DidReceiveMovieDetail")


func requestDetails(id: String) {
    let URLAddress: String = "https://connect-boxoffice.run.goorm.io/movie?id=" + id
    guard let apiURL: URL = URL(string: URLAddress)
        else {return}
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let data = data
            else {return}
        
        do {
            let apiResponse: Detail = try JSONDecoder().decode(Detail.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMovieDetailNotification, object: nil, userInfo: ["details": apiResponse])
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}

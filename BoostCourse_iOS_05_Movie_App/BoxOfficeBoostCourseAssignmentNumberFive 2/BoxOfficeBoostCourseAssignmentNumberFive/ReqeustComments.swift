//
//  ReqeustComments.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/15.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

let DidReceiveCommentsNotification: Notification.Name = Notification.Name("DidReceiveComments")

func requestComments() {
    let URLAddress: String = "https://connect-boxoffice.run.goorm.io/comments"
    guard let apiURL: URL = URL(string: URLAddress)
        else { return }
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let data = data
            else { return }
        
        do {
            let apiResponse: CommentsAPIResponse = try
                JSONDecoder().decode(CommentsAPIResponse.self, from: data)
            NotificationCenter.default.post(name: DidReceiveCommentsNotification, object: nil, userInfo: ["comments": apiResponse.comments])
        } catch (let error) {
            print(error.localizedDescription)
        }
        
    }
    dataTask.resume()
}

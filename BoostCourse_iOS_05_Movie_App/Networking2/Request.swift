//
//  Request.swift
//  Networking2
//
//  Created by 최강훈 on 2020/12/04.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

let DidReceiveFriendsNotification: Notification.Name = Notification.Name("DidReceiveFriends")

func requestFriends() {

    guard let url: URL = URL(string: "https://randomuser.me/api/?results=20&inc=name,email,picture")
        else {return}
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data
            else {return}
        
        do {
            let apiResponse: APIResponse =
                try JSONDecoder().decode(APIResponse.self, from: data)

            NotificationCenter.default.post(name: DidReceiveFriendsNotification, object: nil, userInfo: ["friends":apiResponse.results])
            // friends라는 이름으로 apiResponse.results를 실어 보냄.
            // viewController 내의 didReceiveFriendsNotification에서 그것을 받을 예정.
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}

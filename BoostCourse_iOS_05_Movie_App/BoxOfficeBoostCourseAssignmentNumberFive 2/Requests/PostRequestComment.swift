//
//  PostRequestComment.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/27.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

struct PostComment: Codable {
    let movieId: String
    let rating: Double
    let writer: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case movieId = "movie_id"
    }
}

func postComment(movieId: String, rating: Double, writer: String, contents: String) -> Int {
    // 넣는 순서도 순서대로여야 하는 것 같다.
    let comment = PostComment(movieId: movieId, rating: rating, writer: writer, contents: contents)
    guard let uploadData = try? JSONEncoder().encode(comment)
    else {return 1}
    
    var isFailed: Int = 0
    // URL 객체 정의
    let url = URL(string: "https://connect-boxoffice.run.goorm.io/comment")
    
    // URLRequest 객체를 정의
    guard let requestURL = url
        else {
            print("invalid post comment url")
            return (0)
    }
    var request = URLRequest(url: requestURL)
    request.httpMethod = "POST"
    // HTTP 메시지 헤더
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // URLSession 객체를 통해 전송, 응답값 처리
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
        
        // 서버가 응답이 없거나 통신이 실패
        if let e = error {
            NSLog("An error has occured: \(e.localizedDescription)")
            isFailed = 1
            return
        }
        // 응답 처리 로직
        NotificationCenter.default.post(name: DidDismissPostCommentViewController, object: nil, userInfo: nil)
    }
    // POST 전송
    task.resume()
    
    return isFailed
}

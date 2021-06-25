//
//  RequestUtils.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2021/06/25.
//  Copyright © 2021 최강훈. All rights reserved.
//

import Foundation

let DidReceiveMoviesNotification: Notification.Name
    = Notification.Name("DidReceiveMovies")

let DidReceiveMovieDetailNotification: Notification.Name
    = Notification.Name("DidReceiveMovieDetail")

let DidReceiveCommentsNotification: Notification.Name = Notification.Name("DidReceiveComments")

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


class RequestUtils {
    static let shared = RequestUtils()
    
    func postComment(movieId: String, rating: Double, writer: String, contents: String, completion: @escaping (NetworkResult?) -> Void) {
        // 넣는 순서도 순서대로여야 하는 것 같다.
        let comment = PostComment(movieId: movieId, rating: rating, writer: writer, contents: contents)
        guard let uploadData = try? JSONEncoder().encode(comment)
        else {return}
        
        // URL 객체 정의
        let url = URL(string: "https://connect-boxoffice.run.goorm.io/comment")
        
        // URLRequest 객체를 정의
        guard let requestURL = url
        else {
            print("invalid post comment url")
            completion(.failure)
            return
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
                completion(.failure)
                return
            }
            // 응답 처리 로직
            NotificationCenter.default.post(name: DidDismissPostCommentViewController, object: nil, userInfo: nil)
            completion(.success)
        }
        // POST 전송
        task.resume()
    }

    
    func requestMovies(orderType: OrderType, completion: @escaping (NetworkResult?) -> Void) {
        guard let apiURL: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movies?order_type=" + String(orderType.rawValue))
            else { completion(.failure); return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
                completion(.failure)
                return
            }
            guard let data = data
            else { completion(.failure); return }
            
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": apiResponse.movies])
                completion(.success)
            } catch (let err) {
                print(err.localizedDescription)
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
    func requestDetails(id: String, completion: @escaping (NetworkResult?)-> Void) {
        let URLAddress: String = "https://connect-boxoffice.run.goorm.io/movie?id=" + id
        guard let apiURL: URL = URL(string: URLAddress)
        else {
            completion(.failure)
            return
        }
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure)
                return
            }
            guard let data = data
            else { completion(.failure); return }
            
            do {
                let apiResponse: Detail = try JSONDecoder().decode(Detail.self, from: data)
                NotificationCenter.default.post(name: DidReceiveMovieDetailNotification, object: nil, userInfo: ["details": apiResponse])
                completion(.success)
            } catch (let err) {
                print(err.localizedDescription)
                completion(.failure)
            }
        }
        dataTask.resume()
    }

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

    
    private init() {}
}

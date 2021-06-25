//
//  MoviesModel.swift
//  BoxOfficeBoostCourseAssignmentNumberFive
//
//  Created by 최강훈 on 2020/12/04.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let order_type: Int
    let movies: [Movie]
}

struct Movie: Codable {
    let ageLimit: Int
    let imageAddress: String
    let ranking: Int
    let title: String
    let reservationRate: Double
    let rating: Double
    let openingDate: String
    let id: String
    
    func getMovieImageName() -> String {
        switch self.ageLimit {
        case 0:
            return "ic_allages"
        case 12:
            return "ic_12"
        case 15:
            return "ic_15"
        case 19:
            return "ic_19"
        default:
            return ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title, id
        case openingDate = "date"
        case rating = "user_rating"
        case reservationRate = "reservation_rate"
        case ranking = "reservation_grade"
        case ageLimit = "grade"
        case imageAddress = "thumb"
    }
 }

struct DetailMovieInfo: Codable {
    let details: [Detail]
}

struct Detail: Codable {
    let audience: Int?
    let ageLimit: Int?
    let actor: String?
    let duration: Int?
    let title: String?
    let reservationRate: Double?
    let rating: Double?
    let openingDate: String?
    let director: String?
    let id: String?
    let imageAddress: String?
    let synopsis: String?
    let genre: String?
    let ranking: Int?
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, id, synopsis, genre, title
        case ageLimit = "grade"
        case reservationRate = "reservation_rate"
        case rating = "user_rating"
        case imageAddress = "image"
        case openingDate = "date"
        case ranking = "reservation_grade"
    }
}


struct CommentsAPIResponse: Codable {
    let comments: [Comment]
}

struct Comment: Codable {
    let id: String?
    let rating: Double?
    let timestamp: Double?
    let writer: String?
    let movieId: String?
    let contents: String?
    
    enum CodingKeys: String, CodingKey {
        case id, rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
 }

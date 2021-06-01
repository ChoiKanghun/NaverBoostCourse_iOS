//
//  Model.swift
//  Networking2
//
//  Created by 최강훈 on 2020/12/03.
//  Copyright © 2020 최강훈. All rights reserved.
//

import Foundation


/*
 - results: [
   - {
    - name : {
        title: "mr",
    
      },
      email: "juan.ealkd@aldf.com",
    - picture: {
        large: "https://alksndflas.me/api/..."
        medium: "https://..."
        thumbnail: "https://..."
      }
    },
    ...
    ]
 */
   

struct APIResponse: Codable {
    let results: [Friend]
}

struct Friend: Codable {
    struct Name: Codable {
        let title: String
        let first: String
        let last: String

        var full: String {
            return self.title.capitalized + ". " + self.first.capitalized + " " + self.last.capitalized
        }
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    let name: Name
    let email: String
    let picture: Picture
}


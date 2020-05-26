//
//  People.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 27/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct People: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    var character: String?
    var department: String?
    let profilePath: String?
    
    public var profileURL: URL? {
        if profilePath != nil {
            return URL(string: "https://image.tmdb.org/t/p/w185/\(profilePath!)")!
        }else{
            return nil
        }
        
    }
    
}

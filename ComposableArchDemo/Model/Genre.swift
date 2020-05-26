//
//  Genre.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 27/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

//
//  Video.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 30/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct Video: Codable, Identifiable {
    var id: String
    var site: String
    var type: String
    var key: String
}

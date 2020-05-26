//
//  File.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 30/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct SimpleResponce<T: Codable>: Codable  {
    var results: [T]
}

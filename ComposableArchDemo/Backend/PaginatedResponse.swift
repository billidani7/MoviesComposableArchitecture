//
//  PaginatedResponse.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 27/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

/*
 {
   "page": 1,
   "results": [
     {
     }
   ]
   "total_results": 19629,
   "total_pages": 982
}
 */

import ComposableArchitecture
import Foundation

public struct PaginatedResponse<T: Codable>: Codable, Equatable  {
    public static func == (lhs: PaginatedResponse<T>, rhs: PaginatedResponse<T>) -> Bool {
        return lhs.page == rhs.page
    }
    
    public var page: Int?
    public var totalResults: Int?
    public var totalPages: Int?
    public var results: [T]
    
    init(){
        
        page = 0
        results = []
    }
    
    init(results: [T]) {
        self.results = results
    }
}

let samplePaginatedResponse = PaginatedResponse<Movie>(results: [sampleMovie])



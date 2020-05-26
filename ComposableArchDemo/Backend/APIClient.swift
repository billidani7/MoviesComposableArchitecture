//
//  APIClient.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 15/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
import ComposableArchitecture

public struct APIClient {
    var getMediaWithFilter: (MediaFilter) -> Effect<PaginatedResponse<Movie>, Never>
    var searchMovies: (String) -> Effect<PaginatedResponse<Movie>, Never>
}

 
extension APIClient{
    
    static let actions = APIClient(
        getMediaWithFilter: { filter in
            return APIService.shared.fetch(endpoint: filter.endPoint(), params:  ["page": "1"])
                .replaceError(with: PaginatedResponse<Movie>())
                .eraseToEffect()
        
    }, searchMovies: { query in
        
        return APIService.shared.fetch(endpoint: .searchMovie, params: ["page": "1", "query": query])
            .replaceError(with: PaginatedResponse<Movie>())
            .eraseToEffect()
        
    })
}


// MARK: - Mock API implementations

extension APIClient{

    static let unimplemented = APIClient(
      getMediaWithFilter: { _ in fatalError("Unimplemented") },
      searchMovies: { _ in fatalError("Unimplemented") }
    )
    
    static let mock = APIClient(
        getMediaWithFilter: { _ in
            Effect(value: samplePaginatedResponse)
    },
        searchMovies: { _ in
            Effect(value: samplePaginatedResponse)
            
    })

}

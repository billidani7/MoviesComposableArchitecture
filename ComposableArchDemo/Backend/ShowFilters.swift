//
//  ShowFilters.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 27/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

// "The Movie Database API", supports specific types of lists such as polular, trending or top rated.
// Each of these types would apply on Movies or Tv Shows. MediaFilter enum describes these types

enum MediaFilter {
    case popular(MediaType), trending(MediaType), topRated(MediaType)
    
    func title() -> String {
        switch self {
        case .popular: return "Popular"
        case .trending: return "Trending"
        case .topRated: return "Top Rated"
        }
    }
    
    func endPoint() -> APIService.Endpoint {
        switch self {
        case .popular(let mediaType): return APIService.Endpoint.popular(mediaType)
        case .trending(let mediaType): return APIService.Endpoint.trending(mediaType)
        case .topRated(let mediaType): return APIService.Endpoint.topRated(mediaType)
        }
    
    }
    
    func getMediaTypeString() -> String {
        
        let type: MediaType
        switch self {
        case .popular(let mediaType):
            type = mediaType
        case .trending(let mediaType):
            type = mediaType
        case .topRated(let mediaType):
            type = mediaType
        }
        
        let mediaType: String
        switch type {
        case .movieType:
            mediaType = "movie"
        default:
            mediaType = "tv"
        }
        
        return mediaType
        
    }
}

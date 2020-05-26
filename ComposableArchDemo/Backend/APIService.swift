//
//  APIService.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 27/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
import  Combine

public enum MediaType {
    case movieType
    case tvType
}

public struct APIService{
    
    let baseURL = URL(string: "https://api.themoviedb.org/3")!
    let apiKey = "1d9b898a212ea52e283351e521e17871"
    public static let shared = APIService()
    let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    
    public enum APIError: Error {
        case unknown
        case message(reason: String)
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
        case parseError(reason: String)
        
        static func processResponse(data: Data, response: URLResponse) throws -> Data {
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            if (httpResponse.statusCode == 404) {
                throw APIError.message(reason: "Resource not found");
            }
            return data
        }
    }
    
    
    public enum Endpoint {
        case popular(MediaType), trending(MediaType), topRated(MediaType), searchMovie
        
        func path() -> String {
            switch self {
            case .popular(let mediaType):
                return mediaType == .movieType ? "movie/popular" : "tv/popular"
            case .trending(let mediaType) :
                return mediaType == .movieType ? "/trending/movie/day" : "/trending/tv/day"
            case .topRated(let mediaType):
                return mediaType == .movieType ? "/movie/top_rated" : "/tv/top_rated"
            case .searchMovie:
                return "/search/movie"
           
            }
        }
    }
        
    
    public func fetch<T: Codable>(endpoint: Endpoint, params: [String: String]?) -> AnyPublisher<T ,APIError> {
       let queryURL = baseURL.appendingPathComponent(endpoint.path())
       var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
       components.queryItems = [
          URLQueryItem(name: "api_key", value: apiKey),
          URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
       ]
       if let params = params {
           for (_, value) in params.enumerated() {
               components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
           }
       }
        let request = URLRequest(url: components.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                return try APIError.processResponse(data: data, response: response)
        }
        .decode(type: T.self, decoder: self.decoder)
        .mapError{ APIError.parseError(reason: $0.localizedDescription) }
        .eraseToAnyPublisher()
    }
    
    
}

//
//  MoviesCore.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 15/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
import ComposableArchitecture

public struct MoviesState: Equatable {
    var moviesTrending: [Movie] = []
    var tvPopular: [Movie] = []
    var tvTopRated: [Movie] = []

  public init() {}
}

public enum MoviesAction: Equatable {
    case getMoviesTrending
    case moviesTrendingResponce(Result<PaginatedResponse<Movie>, Never>)
    
    case getTvPopular
    case tvPopularResponce(Result<PaginatedResponse<Movie>, Never>)
    
    case getTvTopRated
    case tvTopRatedResponce(Result<PaginatedResponse<Movie>, Never>)
}


public struct MoviesEnvironment {
    var apiClient: APIClient
    var mainQueue:  AnySchedulerOf<DispatchQueue>
    
    public init(
      apiClient: APIClient,
      mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
      self.apiClient = apiClient
      self.mainQueue = mainQueue
    }
    
}


public let moviesReducer = Reducer<MoviesState, MoviesAction, MoviesEnvironment> {
    state, action, environment in
    switch action {
    
    case .getMoviesTrending:
        return environment.apiClient.getMediaWithFilter(.trending(.movieType))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(MoviesAction.moviesTrendingResponce)
                
    case let .moviesTrendingResponce(.success(responce)):
        state.moviesTrending = responce.results
        return .none
    
    case .getTvPopular:
        return environment.apiClient.getMediaWithFilter(.popular(.tvType))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(MoviesAction.tvPopularResponce)
    
    case let .tvPopularResponce(.success(responce)):
        state.tvPopular = responce.results
        return .none
    
    case .getTvTopRated:
        return environment.apiClient.getMediaWithFilter(.topRated(.tvType))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(MoviesAction.tvTopRatedResponce)
    
    case let .tvTopRatedResponce( .success(responce)):
        state.tvTopRated = responce.results
        return .none
    }


}

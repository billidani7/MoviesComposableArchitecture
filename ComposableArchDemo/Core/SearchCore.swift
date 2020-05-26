//
//  SearchCore.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 16/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
import ComposableArchitecture

// MARK: - Search feature domain

public struct SearchState: Equatable{
    var movies: [Movie] = []
    var searchQuery = ""
    
    public init() {}
}

public enum SearchAction: Equatable{
    case moviesResponce(Result<PaginatedResponse<Movie>, Never>)
    case searchQueryChanged(String)
}


public struct SearchEnvironment {
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


// MARK: - Search feature reducer


public let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    
    state, action, environment in
    switch action {
        
    case let .moviesResponce(.success(response)):
        state.movies = response.results
         return .none
    
    case let .searchQueryChanged(query):
        struct SearchMovieId: Hashable {}
        
        state.searchQuery = query
        // When the query is cleared we can clear the search results, but we have to make sure to cancel
        // any in-flight search requests too, otherwise we may get data coming in later.
        guard !query.isEmpty else {
          state.movies = []
        
          return .cancel(id: SearchMovieId())
        }
        
        return environment
            .apiClient
            .searchMovies(query)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .debounce(id: SearchMovieId(), for: 0.3, scheduler: environment.mainQueue)
            .map(SearchAction.moviesResponce)
    }

}

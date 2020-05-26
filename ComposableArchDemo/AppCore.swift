//
//  AppCore.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 15/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
import ComposableArchitecture

public struct AppState: Equatable {
    public var movies: MoviesState? = MoviesState()
    public var search: SearchState? = SearchState()
    
    public init() {}
    
}

public enum AppAction: Equatable{
    case movies(MoviesAction)
    case search(SearchAction)
}

public struct AppEnvironment {
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


public let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
    Reducer { state, action, _ in
        switch action {
        case .movies:
            return .none
        case .search(_):
            return .none
        }
        
    },
    moviesReducer.optional.pullback(
        state: \.movies,
        action: /AppAction.movies,
        environment: {
            MoviesEnvironment(apiClient: $0.apiClient,
                              mainQueue: $0.mainQueue)
            }
    ),
    
    searchReducer.optional.pullback(
        state: \.search,
        action: /AppAction.search,
        environment: {
            SearchEnvironment(apiClient: $0.apiClient,
                              mainQueue: $0.mainQueue)}
    )



)

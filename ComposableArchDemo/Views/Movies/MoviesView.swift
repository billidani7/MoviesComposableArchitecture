//
//  MoviesView.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 15/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct MoviesView: View {
    
    struct ViewState: Equatable {
        var moviesTrending: [Movie]
        var tvPopular: [Movie]
        var tvTopRated: [Movie]
        
    }
    
    enum ViewAction {
        case getMoviesTrending
        case moviesTrendingResponce(Result<PaginatedResponse<Movie>, Never>)
        
        case getTvPopular
        case tvPopularResponce(Result<PaginatedResponse<Movie>, Never>)
        
        case getTvTopRated
        case tvTopRatedResponce(Result<PaginatedResponse<Movie>, Never>)
    }
    
    let store: Store<MoviesState, MoviesAction>
    
    public init(store: Store<MoviesState, MoviesAction>){
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store.scope(state: {$0.view}, action: MoviesAction.view)){ viewStore in
            
            ScrollView {
                
                VStack(spacing: 2){
                    Text("Trending movies")
                    .font(.title)
                    .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.top, 20)
                    
                    CarouselBackdropView(movies: viewStore.state.moviesTrending)
                       .onAppear() {
                           if viewStore.state.moviesTrending.count == 0 {
                               viewStore.send(.getMoviesTrending)
                           }
                       }
                    
                    
                    Text("Popular TV shows")
                    .font(.title)
                    .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                    CarouselPosterView(movies: viewStore.state.tvPopular)
                        .onAppear() {
                            if viewStore.state.tvPopular.count == 0 {
                                viewStore.send(.getTvPopular)
                            }
                    }
                    
                    Text("Top Rated TV shows")
                    .font(.title)
                    .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                    CarouselPosterView(movies: viewStore.state.tvTopRated)
                        .onAppear() {
                            if viewStore.state.tvTopRated.count == 0 {
                                viewStore.send(.getTvTopRated)
                            }
                    }
                }
                
                
                
                
                
            }
            
        }
        
    }
}

extension MoviesState {
    var view: MoviesView.ViewState {
        MoviesView.ViewState(moviesTrending: self.moviesTrending,
                             tvPopular: self.tvPopular,
                             tvTopRated: self.tvTopRated
        )
    }
    
}

extension MoviesAction {
    static func view(_ localAction: MoviesView.ViewAction) -> Self {
        
        switch localAction {
        case .getMoviesTrending:
            return .getMoviesTrending
        case let .moviesTrendingResponce(responce):
            return self.moviesTrendingResponce(responce)
            
        case .getTvPopular:
            return .getTvPopular
        case let .tvPopularResponce(responce):
            return .tvPopularResponce(responce)
        
        case .getTvTopRated:
            return .getTvTopRated
        case let .tvTopRatedResponce(responce):
            return .tvTopRatedResponce(responce)
        }
        
    }
}

struct MoviesView_Previews: PreviewProvider {
    
    static let store = Store(
        initialState: MoviesState(),
        reducer: moviesReducer,
        environment: MoviesEnvironment(
            apiClient: .mock,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )
    
    static var previews: some View {
        MoviesView(store: store)
    }
}




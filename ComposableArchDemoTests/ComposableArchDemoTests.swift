//
//  ComposableArchDemoTests.swift
//  ComposableArchDemoTests
//
//  Created by Vasilis Daningelis on 16/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Combine
import ComposableArchitecture
import XCTest

@testable import ComposableArchDemo

class ComposableArchDemoTests: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    lazy var environment = SearchEnvironment(
      apiClient: .unimplemented,
      mainQueue: AnyScheduler(self.scheduler)
    )
    
    func testSearchAndClearQuery() {
       let store = TestStore(
         initialState: .init(),
         reducer: searchReducer,
         environment: self.environment
       )

       store.assert(
         .environment {
            $0.apiClient.searchMovies =  { _ in Effect(value: .init(results: [sampleMovie]) ) }
            //$0.weatherClient.searchLocation = { _ in Effect(value: mockLocations) }
         },
         .send(.searchQueryChanged("S")) {
           $0.searchQuery = "S"
         },
         .do { self.scheduler.advance(by: 0.3) },
         .receive(.moviesResponce(.success(.init(results: [sampleMovie]) ))) {
           $0.movies = [sampleMovie]
         },
         .send(.searchQueryChanged("")) {
           $0.movies = []
           $0.searchQuery = ""
         }
       )
     }


}


//private let mockMovies = [
//    Movie(id: 0, originalTitle: nil, originalName: "Joker", name: "Jocker",  overview: "Test desc", posterPath: "/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg", backdropPath: "/f5F4cRhQdUbyVbB5lTNCwUzD6BP.jpg", voteAverage: 8.2, voteCount: 2312, genres: [Genre(id: 0, name: "Adventure")], credits: [:])
//]

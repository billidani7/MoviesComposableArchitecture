//
//  ContentView.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 15/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @State private var selection = 0
    
    let store = Store(initialState: AppState(),
                      reducer: appReducer.debug(),
                      environment: AppEnvironment(
                        apiClient: .actions,
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                      )
    )
 
    var body: some View {
        TabView(selection: $selection){
            
            IfLetStore(self.store.scope(state: { $0.movies }, action: AppAction.movies)) { store in
                MoviesView(store: store)
            }
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "film")
                    Text("Movies")
                }
            }
            .tag(0)
            
            IfLetStore(self.store.scope(state: { $0.search }, action: AppAction.search)) { store in
                SearchView(store: store)
            }
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            }
            .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

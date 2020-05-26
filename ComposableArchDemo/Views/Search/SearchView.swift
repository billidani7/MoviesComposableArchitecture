//
//  SearchView.swift
//  ComposableArchDemo
//
//  Created by Vasilis Daningelis on 16/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

public struct SearchView: View {
    
    struct ViewState: Equatable {
        var movies: [Movie]
        var searchQuery: String
    }
    
    enum  ViewAction {
        case moviesResponce(Result<PaginatedResponse<Movie>, Never>)
        case searchQueryChanged(String)
    }
    
    let store: Store<SearchState, SearchAction>
    
    public init(store: Store<SearchState, SearchAction>){
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store.scope(state: {$0.view}, action: SearchAction.view)){ viewStore in
            VStack {
                SearchField(searchText: viewStore.binding(get: { $0.searchQuery },
                                                          send: ViewAction.searchQueryChanged)
                )
                
                List {
                    ForEach(viewStore.movies, id: \.id, content: movieItemRow)
                }
            }
            .modifier(DismissingKeyboardOnSwipe())
        }
    }
}

// MARK: - Search feature view

struct SearchField: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "magnifyingglass")
            TextField("Find movies...", text: $searchText)
                .font(.system(size: 18, weight: .regular))
                    
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(.horizontal, 15)
        .padding(.top, 20)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)

    }
}


struct MovieRowView: View {
    
    let movie: Movie
    @State var showDetails: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
            
            ZStack {
                WebImage(url: movie.posterURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 120 , alignment:  .top)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .blur(radius: 10)
                    .offset(y: 10)
                
                WebImage(url: movie.posterURL)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(Color.gray.opacity(0.4))
                            .frame(width: 80, height: 120)
                    }
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade) // Fade Transition
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 120)
                    //.frame(width: posterSize.width, height: posterSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(movie.finalTitle)")
                    .lineLimit(2)
                    .font(.system(.subheadline))
                
                
                Text("21 July 2017")
                    .font(.system(.subheadline))
                    .foregroundColor(Color(#colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)))
                            
                HStack {
                    RingView(color1: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), color2: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), width: 33, height: 33, percent: CGFloat(movie.voteAverage) * 10, show: .constant(true) )
                        //.animation(Animation.easeInOut.delay(0.4))
                        .onAppear() {
                            //self.showRing = true
                            
                    }
                    
                    Text("\(movie.voteCount)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(#colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)))
                }
  
            }
            Spacer()
        }
        .padding()
        .frame(width: screen.width - 30, height: 150)
        .background(Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .onTapGesture {
            //print("TAPPPP")
            self.showDetails.toggle()
        }

    }
}

private func movieItemRow(movie: Movie) -> some View {
    
    MovieRowView(movie: movie)
}

extension SearchState {
    var view: SearchView.ViewState {
        SearchView.ViewState(movies: self.movies, searchQuery: self.searchQuery)
    }
}

extension SearchAction {
    static func view(_ localAction: SearchView.ViewAction) -> Self {
        
        switch localAction {
        case let .moviesResponce(responce):
            return self.moviesResponce(responce)
        
        case let .searchQueryChanged(query):
            return self.searchQueryChanged(query)
        }
    }
}




// MARK: - SwiftUI preview


struct SearchView_Previews: PreviewProvider {
    
    static let previewStore = Store(
        initialState: SearchState(),
        reducer: searchReducer,
        environment: SearchEnvironment(
            apiClient: .mock,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )
    
    static var previews: some View {
        SearchView(store: previewStore )
    }
}

let screen = UIScreen.main.bounds




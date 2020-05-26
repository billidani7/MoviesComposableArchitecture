# Composable Architecture
Redux-like Architecture with SwiftUI

![ezgif.com-resize-2.gif](https://imgshare.io/images/2020/05/26/ezgif.com-resize-2.gif)

## Core Concepts
**State**  
State is the single source of truth. Your state is immutable. The only way to transition from one State to another is to emit an Action. Reducers will handle the actions by implementing a different state change for each action.

**Action**  
A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.

**Reducer**  
A function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for returning any effects that should be run, such as API requests.

**Store**  
The runtime that actually drives your feature. You send all user actions to the store so that the store can run the reducer and effects, and you can observe state changes in the store so that you can update UI.

## Define actions  
**Let’s take a look at the example code**
We’re going to start with a little feature modeling. We are going to describe the search movie feature. First of all we will define the actions. For example, the user can type a search query. Because we want to implement search-as-you type functionality, we would like to get notified when the user types in the textfield. This is an action. 

```Swift
public enum SearchAction: Equatable {
    case searchQueryChanged(String)
}
```
Another action is when we get a response from the API. We will add this Action to the emum that we have created before.
```Swift
public enum SearchAction: Equatable {
    case searchQueryChanged(String) //Action when user types in text field
    case moviesResponce(Result<PaginatedResponse<Movie>, Never>) //Action when we get results from API
}
```

## Define state  
We’ll define the state of our search feature.
We want to hold what user typed in the text filed, and when we get a response from the API, we want to hold the response (Movies).
```Swift
public struct SearchState: Equatable {
    var movies: [Movie] = [] //results from API
    var searchQuery = "" //user's search term
}
```
## Define reducer  
Next we would define a reducer for our search feature, which is the thing that glues together the state and the action into a package. It’s the thing responsible for the business logic. Business logic corresponds to just two things:
1) We will make any mutations to the state necessary for the action
2) After you have performed all of the mutations you want to state, you can return an effect. An effect is a special type that allows you to communicate with the outside world, like executing an API request, writing data to disk, or tracking analytics, and it allows you to feed data from the outside world back into this reducer.

```Swift
public let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    state, action, environment in
    
    switch action {
        
    case let .moviesResponce(.success(response)): //4. <- API responce
        state.movies = response.results //update the state
        return .none // no effect (action) 
    
    case let .searchQueryChanged(query): //1. User types letters
        
        return environment
            .apiClient
            .searchMovies(query)  //2. <- API call
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .debounce(id: SearchMovieId(), for: 0.3, scheduler: environment.mainQueue)
            .map(SearchAction.moviesResponce) //3. <- return new effect along with API responce. (action)
    }

}

```

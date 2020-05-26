# Composable Architecture
Redux-like Architecture with SwiftUI


## Core Concepts
**State**  
State is the single source of truth. Your state is immutable. The only way to transition from one State to another is to emit an Action. Reducers will handle the actions by implementing a different state change for each action.

**Action**  
A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.

**Reducer**  
A function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for returning any effects that should be run, such as API requests.

**Store**  
The runtime that actually drives your feature. You send all user actions to the store so that the store can run the reducer and effects, and you can observe state changes in the store so that you can update UI.

# MVVM.Demo.SwiftUI
 
# MVVM - Model View ViewModel
MVVM Wiki: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel

## Overview
### View
- UI elements
- Reacts to and interprets ViewModel through bindings 
- Contains no business logic
- Stateless<sup>1</sup>
- Holds a reference to the ViewModel

### ViewModel
- Model interpretation 
- Business logic 
- Bindable properties
- Domain model dependencies injected as Protocols 
- May contain child ViewModels 
- Does not know about View

### Model
- Anything that provides data or state to the ViewModel
- Does not know about the View or ViewModel

<sup>1</sup> No meaningful state is stored within the view. Anything needed by the model layer is immediately sent to the ViewModel from the View.

# Coordinators
- Coordinators are aware of the user’s navigation context within the app
- Primarily responsible for Navigation and ViewModel injection
- Can contain child coordinators which are responsible for a narrowed context
- Only object to have a reference to the Dependency Injection container/resolver

# Dependency Injection Container
- Manages references and lifetimes of registered objects 
- Reduces the burden of dependency injection by defining all injections in one place 
- Greatly improves the ability to unit test your code by registering contained objects as Protocols which can be substituted with mocks
- Makes sharing observable data throughout the app trivial while keeping each class/service focused and independent

# Looking for older iOS Examples?

## iOS 16
https://github.com/jasonjrr/MVVM.Demo.SwiftUI/releases/tag/3.0.0

## iOS 14 & 15
https://github.com/jasonjrr/MVVM.Demo.SwiftUI/releases/tag/2.1.0

Version `2.1.0` was built on iOS 14 and solves the navigation problems most developers experiences with `NavigationView`.  

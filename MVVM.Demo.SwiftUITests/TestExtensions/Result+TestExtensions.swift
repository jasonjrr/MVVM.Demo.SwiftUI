//
//  Result+TestExtensions.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 12/23/21.
//

import Foundation

extension Result {
  var value: Success? {
    switch self {
    case .success(let value): return value
    case .failure: return nil
    }
  }
  
  var error: Failure? {
    switch self {
    case .success: return nil
    case .failure(let error): return error
    }
  }
  
  var isSuccess: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }
  
  var isFailure: Bool {
    switch self {
    case .success: return false
    case .failure: return true
    }
  }
}

extension Result where Success == Void {
  var valueIsVoid: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }
}

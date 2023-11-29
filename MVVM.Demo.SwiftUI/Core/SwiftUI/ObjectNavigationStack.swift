//
//  ObjectNavigationStack.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 12/5/22.
//

import SwiftUI

struct ObjectNavigationStack<Content>: View where Content : View {
  @State var path: ObjectNavigationPath
  let content: () -> Content
  
  var body: some View {
    NavigationStack(path: self.$path.path, root: self.content)
  }
}

@Observable
class ObjectNavigationPath {
  typealias NavigationObject = AnyObject & Hashable & Equatable
  fileprivate var path: NavigationPath = NavigationPath()
  private var objects: [any NavigationObject] = []
  
  private let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
  
  var last: (any NavigationObject)? {
    self.objects.last
  }
  
  func append(_ object: some NavigationObject) {
    self.semaphore.wait()
    self.objects.append(object)
    self.path.append(object)
    self.semaphore.signal()
  }
  
  func removeLast() {
    self.semaphore.wait()
    self.objects.removeLast()
    self.path.removeLast()
    self.semaphore.signal()
  }
  
  @discardableResult
  func removeLast<Element : NavigationObject>(through graphObject: Element) -> Element? {
    self.semaphore.wait()
    var removeCount: Int = 0
    defer {
      self.path.removeLast(removeCount)
      self.semaphore.signal()
    }
    
    while let object = self.objects.popLast() {
      removeCount = removeCount + 1
      if graphObject === object {
        return graphObject
      }
    }
    return nil
  }
  
  @discardableResult
  func removeLast(through clause: (any NavigationObject) -> Bool) -> (any NavigationObject)? {
    self.semaphore.wait()
    var removeCount: Int = 0
    defer {
      self.path.removeLast(removeCount)
      self.semaphore.signal()
    }
    
    while let object = self.objects.popLast() {
      removeCount = removeCount + 1
      if clause(object) {
        return object
      }
    }
    return nil
  }
}


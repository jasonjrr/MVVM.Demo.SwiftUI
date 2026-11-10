//
//  CoordinatorNavigationStack.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct CoordinatorNavigationStack<Content>: View where Content : View {
  @Bindable var path: CoordinatorNavigationPath
  let content: Content

  init(path: CoordinatorNavigationPath, @ViewBuilder content: () -> Content) {
    self.path = path
    self.content = content()
  }

  var body: some View {
    NavigationStack(path: self.$path.path) {
      self.content
    }
    .onChange(of: self.path.path) { oldValue, newValue in
      // Keeps `objects` in step when the user pops with the back button or a swipe.
      if oldValue.count == newValue.count + 1
          && self.path.objectCount == oldValue.count {
        self.path.removeLastObjectOnly()
      }
    }
  }
}

@Observable @MainActor
final class CoordinatorNavigationPath {
  typealias NavigationObject = AnyObject & Hashable & Equatable
  fileprivate var path: NavigationPath = NavigationPath()
  private var objects: [any NavigationObject] = []
  fileprivate var objectCount: Int { self.objects.count }

  var last: (any NavigationObject)? {
    self.objects.last
  }

  func append(_ object: some NavigationObject) {
    self.objects.append(object)
    self.path.append(object)
  }

  func removeAll() {
    self.objects.removeAll()
    self.path.removeLast(self.path.count)
  }

  func removeLast() {
    self.objects.removeLast()
    self.path.removeLast()
  }

  @discardableResult
  func removeLast<Element : NavigationObject>(through graphObject: Element) -> Element? {
    var removeCount: Int = 0
    defer { self.path.removeLast(removeCount) }

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
    var removeCount: Int = 0
    defer { self.path.removeLast(removeCount) }

    while let object = self.objects.popLast() {
      removeCount = removeCount + 1
      if clause(object) {
        return object
      }
    }
    return nil
  }

  fileprivate func removeLastObjectOnly() {
    self.objects.removeLast()
  }
}

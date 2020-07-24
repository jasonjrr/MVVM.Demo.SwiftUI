//
//  View+Navigation.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//
//  https://quickbirdstudios.com/blog/coordinator-pattern-in-swiftui/

import SwiftUI

extension View {
  func onNavigation(_ action: @escaping () -> Void) -> some View {
    let isActive = Binding(
      get: { false },
      set: { newValue in
        if newValue {
          action()
        }
      }
    )
    return NavigationLink(
      destination: EmptyView(),
      isActive: isActive
    ) {
      self
    }
  }
  
  func navigation<Item, Destination: View>(item: Binding<Item?>, @ViewBuilder destination: (Item) -> Destination) -> some View {
    let isActive = Binding(
      get: { item.wrappedValue != nil },
      set: { value in
        if !value {
          item.wrappedValue = nil
        }
      }
    )
    return navigation(isActive: isActive) {
      item.wrappedValue.map(destination)
    }
  }
  
  func navigation<Destination: View>(isActive: Binding<Bool>, @ViewBuilder destination: () -> Destination) -> some View {
    overlay(
      NavigationLink(
        destination: isActive.wrappedValue ? destination() : nil,
        isActive: isActive,
        label: { EmptyView() }
      )
    )
  }
}

extension NavigationLink {
  init<T: Identifiable, D: View>(item: Binding<T?>, @ViewBuilder destination: (T) -> D, @ViewBuilder label: () -> Label) where Destination == D? {
    let isActive = Binding(
      get: { item.wrappedValue != nil },
      set: { value in
        if !value {
          item.wrappedValue = nil
        }
      }
    )
    self.init(
      destination: item.wrappedValue.map(destination),
      isActive: isActive,
      label: label
    )
  }
}

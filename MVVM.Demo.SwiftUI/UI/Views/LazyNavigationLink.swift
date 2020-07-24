//
//  NavigationLazyView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/18/20.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    @Binding var isActive: Bool
    let content: () -> Content
    
    init(isActive: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isActive = isActive
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if self.isActive {
                self.content()
            } else {
                EmptyView()
            }
        }
    }
}

/// Note: Navigation Links currently hold references
/// to any classes/objects passed into them, even
/// after being dismissed. In this case it is just
/// our settings screen, so it is not a big deal,
/// but in larger apps we will start to leak
/// considerable amounts of memory if we follow the
/// traditional push/pop style iOS apps have used
/// for years.
struct LazyNavigationLink<Label, Destination>: View where Label: View, Destination: View {
    let destination: () -> Destination
    @Binding var isActive: Bool
    let label: () -> Label
    
    @State private var showDestination: Bool = false
    
    init(@ViewBuilder destination: @escaping () -> Destination, isActive: Binding<Bool>, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self._isActive = isActive
        self.label = label
    }
    
    var body: some View {
        NavigationLink(
            destination: NavigationLazyView(isActive: self.$isActive, content: self.destination),
            isActive: self.$isActive,
            label: self.label)
    }
}

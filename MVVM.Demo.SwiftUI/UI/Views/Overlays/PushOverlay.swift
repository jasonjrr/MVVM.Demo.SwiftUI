//
//  PushOverlay.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/21/20.
//

import SwiftUI

struct PushOverlay<Content>: View where Content: View {
    @Binding var isActive: Bool
    let showDuration: TimeInterval
    let didDismiss: () -> Void
    let content: () -> Content
    
    @State private var dragOffset: CGFloat = 0
    
    init(isActive: Binding<Bool>, showDuration: TimeInterval = 0.3, didDismiss: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self._isActive = isActive
        self.showDuration = showDuration
        self.didDismiss = didDismiss
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if self.isActive {
                self.content()
                    .transition(.move(edge: .trailing))
                    .animation(.easeOut(duration: self.showDuration))
            } else {
                EmptyView()
            }
        }
        .offset(x: self.dragOffset, y: 0)
        .gesture(DragGesture()
            .onChanged { (gesture: DragGesture.Value) in
                guard self.isActive else { return }
                if gesture.startLocation.x < 44 {
                    self.dragOffset = gesture.location.x
                }
            }
            .onEnded{ (gesture: DragGesture.Value) in
                if gesture.startLocation.x < 44 {
                    if gesture.location.x > 160 {
                        if self.isActive {
                            self.didDismiss()
                            self.dragOffset = 0
                        }
                    } else {
                        self.dragOffset = 0
                    }
                }
            }
        )
    }
}

struct Push<Parent, Child>: View where Parent: View, Child: View {
    @Binding var isChildActive: Bool
    let showDuration: TimeInterval
    let hideDuration: TimeInterval
    let parent: Parent
    let child: () -> Child
    
    init(isChildActive: Binding<Bool>, showDuration: TimeInterval = 0.3, hideDuration: TimeInterval = 0.3, parent: Parent, @ViewBuilder child: @escaping () -> Child) {
        self._isChildActive = isChildActive
        self.showDuration = showDuration
        self.hideDuration = hideDuration
        self.parent = parent
        self.child = child
    }
    
    var body: some View {
        self.parent
            .offset(x: self.isChildActive ? -64 : 0, y: 0)
            .animation(.easeInOut(duration: self.showDuration))
            .overlay(
                ZStack {
                    if self.isChildActive {
                        self.child()
                            .transition(.move(edge: .trailing))
                            .animation(.easeOut(duration: self.showDuration))
                    }
                }
            )
    }
}

extension View {
    func pushTransition<Child>(isChildActive: Binding<Bool>, showDuration: TimeInterval = 0.3, hideDuration: TimeInterval = 0.3, @ViewBuilder child: @escaping () -> Child) -> some View where Child: View {
        Push(
            isChildActive: isChildActive,
            showDuration: showDuration,
            hideDuration: hideDuration,
            parent: self,
            child: child)
    }
}

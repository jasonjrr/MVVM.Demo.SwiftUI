//
//  ModalOverlay.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/20/20.
//

import SwiftUI

struct ModalOverlay<Content>: View where Content: View {
    @Binding var isActive: Bool
    let showDuration: TimeInterval
    let hideDuration: TimeInterval
    let didTapOutsideModal: (() -> Void)?
    let content: () -> Content
    
    init(isActive: Binding<Bool>, showDuration: TimeInterval = 0.375, hideDuration: TimeInterval = 0.375, didTapOutsideModal: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self._isActive = isActive
        self.showDuration = showDuration
        self.hideDuration = hideDuration
        self.didTapOutsideModal = didTapOutsideModal
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if self.isActive {
                Rectangle()
                    .fill(Color.clear)
                    .animation(nil)
                    .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
                    .frame(
                        minWidth: 0, maxWidth: .infinity,
                        minHeight: 0, maxHeight: .infinity)
                    .transition(AnyTransition
                        .opacity
                        .animation(
                            self.isActive
                                ? .easeOut(duration: self.showDuration)
                                : .easeIn(duration: self.hideDuration)))
                    .onTapGesture {
                        self.didTapOutsideModal?()
                    }
                self.content()
            }
        }
    }
}

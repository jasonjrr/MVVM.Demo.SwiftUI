//
//  LandingButtonStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/16/20.
//

import SwiftUI

struct LandingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 18).bold())
            .foregroundColor(Color.label)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.secondarySystemBackground)
                    .frame(
                        minWidth: 200,
                        idealWidth: .infinity,
                        minHeight: 52,
                        idealHeight: 52,
                        maxHeight: 52)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(radius: 8)
            )
            .frame(
                minWidth: 200,
                idealWidth: .infinity,
                minHeight: 52,
                idealHeight: 52,
                maxHeight: 52)
            .fixedSize(horizontal: false, vertical: true)
            .opacity(configuration.isPressed ? 0.66 : 1.0)
            .animation(.easeInOut)
    }
}

//
//  ToolbarButtonStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/24/20.
//

import SwiftUI

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.headline.weight(.semibold))
            .foregroundColor(.accentColor)
    }
}

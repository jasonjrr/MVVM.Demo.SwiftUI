//
//  LandingView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct LandingView: View {
  @ObservedObject var viewModel: LandingViewModel
  
  @State private var isAuthenticated: Bool = false
  @State private var username: String = .empty
  @State private var pulseColor: Color = .accentColor
  
  var body: some View {
    ZStack {
      VStack(alignment: .center, spacing: 24.0) {
        Button(action: self.viewModel.signInOrOut) {
          Text(self.isAuthenticated ? "Sign Out, \(self.username)" : "Sign In")
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .padding(8.0)
            .frame(maxWidth: .infinity, minHeight: 54.0, maxHeight: .infinity)
            .fixedSize(horizontal: false, vertical: true)
            .contentShape(Rectangle())
        }
        .buttonStyle(BrightBorderedButtonStyle())
        
        Button(action: self.viewModel.pulse) {
          Text("Pulse")
            .frame(maxWidth: .infinity, minHeight: 54.0, idealHeight: 54.0, maxHeight: 54.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(BrightBorderedButtonStyle(color: self.pulseColor))
        
        Button(action: self.viewModel.colorWizard) {
          Text("Color Wizard")
            .frame(maxWidth: .infinity, minHeight: 54.0, idealHeight: 54.0, maxHeight: 54.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(BrightBorderedButtonStyle())
      }
      
      .padding([.leading, .trailing], 48.0)
    }
    .navigationBarHidden(true)
    .onReceive(self.viewModel.isAuthenticated.receive(on: .main)) {
      self.isAuthenticated = $0
    }
    .onReceive(self.viewModel.username.receive(on: .main)) {
      self.username = $0
    }
    .onReceive(self.viewModel.pulseColor.receive(on: .main), withAnimation: .easeInOut) {
      self.pulseColor = $0
    }
  }
}

#if DEBUG
struct LandingView_Previews: PreviewProvider {
  static let appAssembler = AppAssembler()
  static let viewModel = appAssembler.resolver.resolve(LandingViewModel.self)!
  
  static var previews: some View {
    Group {
      LandingView(viewModel: viewModel)
    }
  }
}
#endif

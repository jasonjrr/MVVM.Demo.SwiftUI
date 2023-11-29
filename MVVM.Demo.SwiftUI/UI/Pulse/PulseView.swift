//
//  PulseView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/16/21.
//

import SwiftUI

struct PulseView: View {
  @State var viewModel: PulseViewModel
  
  @State private var title: String = .empty
  
  var body: some View {
    ZStack {
      ForEach(self.viewModel.colors) { item in
        PulseCircle(viewModel: item)
          .frame(
            width: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height),
            height: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
          )
      }
    }
    .navigationTitle(self.title)
    .navigationBarTitleDisplayMode(.inline)
    .overlay(.thinMaterial)
    .onReceive(self.viewModel.title.receive(on: .main)) {
      self.title = $0
    }
  }
}

extension PulseView {
  struct PulseCircle: View {
    @State var viewModel: PulseViewModel.ColorItem
    
    var body: some View {
      Circle()
        .fill(Color.white)
        .colorMultiply(self.viewModel.color)
        .opacity(self.viewModel.opacity)
        .animation(.easeIn, value: self.viewModel.opacity)
        .onAppear {
          withAnimation {
            self.viewModel.opacity = 1.0
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            withAnimation {
              self.viewModel.opacity = 0.0
            }
          }
        }
    }
  }
}

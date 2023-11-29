//
//  ColorWizardContentView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import SwiftUI

struct ColorWizardContentView: View {
  @State var viewModel: ColorWizardContentViewModel
  
  var body: some View {
    ZStack {
      if let color = self.viewModel.color {
        Rectangle()
          .fill(Color.clear)
          .background(color)
      } else {
        ScrollView {
          VStack {
            ForEach(self.viewModel.colors, id: \.id) { color in
              RoundedRectangle(cornerRadius: 36.0, style: .continuous)
                .fill(color.color)
                .frame(maxWidth: .infinity, minHeight: 54.0, idealHeight: 54.0, maxHeight: 54.0)
                .padding([.leading, .trailing], 16.0)
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle(self.viewModel.title)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        if self.viewModel.canMoveBack {
          Button(action: { self.viewModel.moveBack() }) {
            Text("Back")
          }
        } else {
          EmptyView()
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        if self.viewModel.canMoveForward {
          Button(action: { self.viewModel.moveForward() }) {
            Text("Forward")
          }
        } else if self.viewModel.canComplete {
          Button(action: { self.viewModel.complete() }) {
            Text("Done")
          }
        } else {
          EmptyView()
        }
      }
    }
  }
}

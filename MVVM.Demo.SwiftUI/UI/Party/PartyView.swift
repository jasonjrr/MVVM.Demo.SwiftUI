//
//  PartyView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/23/20.
//

import SwiftUI

struct PartyView: View {
    @EnvironmentObject var coordinator: AppRootNavigationCoordinator
    @ObservedObject var viewModel: PartyViewModel
    
    @State private var colors: [ColorViewModel] = []
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ZStack {
                ForEach(self.colors) { color in
                    Circle()
                        .fill(color.color)
                        .frame(
                            width: max(geometry.size.height, geometry.size.width) * 2,
                            height: max(geometry.size.height, geometry.size.width) * 2,
                            alignment: .center)
                        .zIndex(Double(color.index))
                        .animation(nil)
                        .transition(AnyTransition.scale(scale: 0).animation(.easeOut(duration: 5)))
                }
            }
            .frame(
                width: geometry.size.width * 2,
                height: geometry.size.height * 2)
            .offset(
                x: -geometry.size.width / 2,
                y: -geometry.size.height / 2)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationTitle("Party!")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                        self.viewModel.onDismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .padding([.leading, .trailing], 16)
                        .offset(x: -16, y: 0)
                })
                .buttonStyle(ToolbarButtonStyle())
            }
        }
        .onReceive(self.viewModel.colors) { colors in
            self.colors = colors
        }
    }
}

struct PartyView_Previews: PreviewProvider {
    static var previews: some View {
        let appAssembler: AppAssembler = AppAssembler()
        let coordinator = appAssembler.resolver.resolve(AppRootNavigationCoordinator.self)!
        let viewModel = appAssembler.resolver.resolve(PartyViewModel.self)!
        NavigationView {
            PartyView(viewModel: viewModel)
                .environmentObject(coordinator)
        }
    }
}

//
//  ContentView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import SwiftUI

struct ContentView: View {
    @Namespace var animation
    @EnvironmentObject var coordinator: AppRootNavigationCoordinator
    @ObservedObject var viewModel: ContentViewModel
    
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        Text("Hello, \(self.viewModel.greetingName)!")
                            .padding()
                            .padding(.top, 64)
                        
                        if self.isAuthenticated {
                            Button(action: {
                                self.coordinator.alert(.signOutAlert)
                            }, label: {
                                Text("Sign Out").bold().padding()
                            })
                            .buttonStyle(LandingButtonStyle())
                            .matchedGeometryEffect(id: "signin.prompt", in: animation)
                        } else {
                            Button(action: {
                                self.viewModel.didTapSignIn()
                            }, label: {
                                Text("Sign In")
                                    .bold()
                                    .padding()
                            })
                            .buttonStyle(LandingButtonStyle())
                            .matchedGeometryEffect(id: "signin.prompt", in: animation, properties: .frame)
                        }
                        
                        Button(action: {
                            self.viewModel.didTapParty()
                        }, label: {
                            Text("Party!").bold().padding()
                                .foregroundColor(.white)
                                .colorMultiply(self.viewModel.partyColor)
                                .animation(.easeInOut)
                        })
                        .buttonStyle(LandingButtonStyle())
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(self.viewModel.partyColor, lineWidth: 3)
                                .animation(.easeInOut)
                        )
                    }
                    .frame(
                        minWidth: 0, maxWidth: .infinity,
                        minHeight: 0, maxHeight: .infinity)
                }
            }
            .navigationTitle(String.empty)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.viewModel.didTapSettings()
                    }, label: {
                        Image(systemName: "gear").imageScale(.large)
                    })
                    .buttonStyle(ToolbarButtonStyle())
                }
            }
        }
        .overlay(
            ZStack {
                PushOverlay(
                    isActive: self.$coordinator.showSettings,
                    didDismiss: { self.coordinator.pop(from: .settings(.root)) }) {
                    NavigationView {
                        SettingsView(viewModel: self.coordinator.settingsViewModelProvider.provide())
                            .environmentObject(self.coordinator)
                    }
                }

                PushOverlay(
                    isActive: self.$coordinator.showParty,
                    didDismiss: { self.coordinator.pop(from: .party) }) {
                    NavigationView {
                        PartyView(viewModel: self.coordinator.partyViewModelProvider.provide())
                            .environmentObject(self.coordinator)
                    }
                }
                
                ModalOverlay(
                    isActive: self.$coordinator.showSignInPrompt,
                    didTapOutsideModal: { self.viewModel.didTapOutsideModal() }) {
                    SignInView(viewModel: self.coordinator.signInViewModelProvider.provide(),
                        parentNamespace: animation)
                        .animation(nil)
                        .padding(.all, 24)
                        .transition(
                            AnyTransition.asymmetric(
                                insertion: AnyTransition
                                    .scale(scale: 0.5, anchor: .top)
                                    .combined(with: .opacity)
                                    .animation(.interactiveSpring(response: 0.375, dampingFraction: 0.75, blendDuration: 0.1)),
                                removal: AnyTransition
                                    .scale(scale: 0.25, anchor: .top)
                                    .combined(with: AnyTransition.opacity.animation(.easeIn(duration: 0.24)))
                                    .animation(.easeIn(duration: 0.24))))
                }
                .keyboardAdaptive()
            }
        )
        .alert(isPresented: self.$coordinator.showSignOutAlert) {
            Alert(
                title: Text("Sign Out"),
                message: Text("Are you sure you want to sign out?"),
                primaryButton: .destructive(Text("Yes, Sign out"), action: { self.viewModel.didTapSignOut() }),
                secondaryButton: .cancel(Text("No")))
        }
        .onReceive(self.viewModel.isAuthenticated) { isAuthenticated in
            withAnimation {
                self.isAuthenticated = isAuthenticated
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let assembler: AppAssembler = AppAssembler()
        return ContentView(viewModel: assembler.resolver.resolve(ContentViewModel.self)!)
            .environmentObject(assembler.resolver.resolve(AppRootNavigationCoordinator.self)!)
    }
}

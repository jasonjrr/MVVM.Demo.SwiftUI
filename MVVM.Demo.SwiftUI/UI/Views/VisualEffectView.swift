//
//  VisualEffectView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
  let effect: UIVisualEffect?
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
  func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = self.effect }
}

struct ProgressiveVisualEffectView: UIViewRepresentable {
  let effect: UIVisualEffect
  let intensity: CGFloat
  
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    UIProgressiveVisualEffectView(effect: self.effect, intensity: self.intensity)
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = self.effect }
}

final class UIProgressiveVisualEffectView: UIVisualEffectView {
  private let theEffect: UIVisualEffect
  private let customIntensity: CGFloat
  private var animator: UIViewPropertyAnimator?
  
  /// Create visual effect view with given effect and its intensity
  ///
  /// - Parameters:
  ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
  ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
  init(effect: UIVisualEffect, intensity: CGFloat) {
    self.theEffect = effect
    self.customIntensity = intensity
    super.init(effect: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { nil }
  
  deinit {
    self.animator?.stopAnimation(true)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    effect = nil
    self.animator?.stopAnimation(true)
    self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
      self.effect = self.theEffect
    }
    self.animator?.fractionComplete = self.customIntensity
  }
}

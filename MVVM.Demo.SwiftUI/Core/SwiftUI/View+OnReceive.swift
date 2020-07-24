//
//  View+OnReceive.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI
import Combine

extension View {
  /// Adds an action to perform when this view detects data emitted by the
  /// given publisher.
  ///
  /// - Parameters:
  ///   - publisher: The publisher to subscribe to.
  ///   - animation: The animation for the received publisher.
  ///   - action: The action to perform when an event is emitted by
  ///     `publisher`. The event emitted by publisher is passed as a
  ///     parameter to `action`.
  ///
  /// - Returns: A view that triggers `action` when `publisher` emits an
  ///   event.
  @inlinable public func onReceive<P>(_ publisher: P, withAnimation animation: Animation?, perform action: @escaping (P.Output) -> Void) -> some View where P : Publisher, P.Failure == Never {
    self.onReceive(publisher) { value in
      withAnimation(animation) {
        action(value)
      }
    }
  }
}

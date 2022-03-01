//
//  Publisher+Extensions.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Combine
import CombineExt

extension Publisher {
  /// Republishes elements received from a publisher, by assigning them to a property marked as a publisher, but does not hold a strong reference to the assigned property.
  ///
  /// Use this operator when you want to receive elements from a publisher and republish them through a property marked with the `@Published` attribute. The `assign(to:)` operator manages the life cycle of the subscription, canceling the subscription automatically when the ``Published`` instance deinitializes. Because of this, the `assign(to:)` operator doesn't return an ``AnyCancellable`` that you're responsible for like ``assign(to:on:)`` does.
  ///
  /// The example below shows a model class that receives elements from an internal <doc://com.apple.documentation/documentation/Foundation/Timer/TimerPublisher>, and assigns them to a `@Published` property called `lastUpdated`. Because the `to` parameter has the `inout` keyword, you need to use the `&` operator when calling this method.
  ///
  ///     class MyModel: ObservableObject {
  ///         @Published var lastUpdated: Date = Date()
  ///         init() {
  ///              Timer.publish(every: 1.0, on: .main, in: .common)
  ///                  .autoconnect()
  ///                  .assign(to: &$lastUpdated)
  ///         }
  ///     }
  ///
  /// If you instead implemented `MyModel` with `assign(to: lastUpdated, on: self)`, storing the returned ``AnyCancellable`` instance could cause a reference cycle, because the ``Subscribers/Assign`` subscriber would hold a strong reference to `self`. Using `assign(to:)` solves this problem.
  ///
  /// While the `to` parameter uses the `inout` keyword, this method doesn't replace a reference type passed to it. Instead, this notation indicates that the operator may modify members of the assigned object, as seen in the following example:
  ///
  ///         class MyModel2: ObservableObject {
  ///             @Published var id: Int = 0
  ///         }
  ///         let model2 = MyModel2()
  ///         Just(100).assign(to: &model2.$id)
  ///
  /// - Parameter published: A property marked with the `@Published` attribute, which receives and republishes all elements received from the upstream publisher.
  func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
    sink { [weak root] in
      root?[keyPath: keyPath] = $0
    }
  }
  
  /// Attaches a subscriber with closure-based behavior.
  ///
  /// Use ``Publisher/sink(receiveCompletion:receiveValue:)`` to observe values received by the publisher and process them using a closure you specify.
  ///
  /// In this example, a <doc://com.apple.documentation/documentation/Swift/Range> publisher publishes integers to a ``Publisher/sink(receiveCompletion:receiveValue:)`` operator’s `receiveValue` closure that prints them to the console. Upon completion the ``Publisher/sink(receiveCompletion:receiveValue:)`` operator’s `receiveCompletion` closure indicates the successful termination of the stream.
  ///
  ///     let myRange = (0...3)
  ///     cancellable = myRange.publisher
  ///         .sink(receiveCompletion: { print ("completion: \($0)") },
  ///               receiveValue: { print ("value: \($0)") })
  ///
  ///     // Prints:
  ///     //  value: 0
  ///     //  value: 1
  ///     //  value: 2
  ///     //  value: 3
  ///     //  completion: finished
  ///
  /// This method creates the subscriber and immediately requests an unlimited number of values, prior to returning the subscriber.
  /// The return value should be held, otherwise the stream will be canceled.
  ///
  /// - parameter receiveComplete: The closure to execute on completion.
  /// - parameter receiveValue: The closure to execute on receipt of a value.
  /// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
  public func sink(receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil) -> AnyCancellable {
    self.sink(receiveCompletion: receiveCompletion ?? { _ in }, receiveValue: { _ in })
  }
  
  /// Attaches a subscriber with closure-based behavior.
  ///
  /// Use ``Publisher/sink(receiveCompletion:receiveValue:)`` to observe values received by the publisher and process them using a closure you specify.
  ///
  /// In this example, a <doc://com.apple.documentation/documentation/Swift/Range> publisher publishes integers to a ``Publisher/sink(receiveValue:,completion:,failure:)`` operator’s `receiveValue` closure that prints them to the console. Upon completion the ``Publisher/sink(receiveValue:,completion:,failure:)`` operator’s `completion` closure indicates the successful termination of the stream. When a failure occurs the ``Publisher/sink(receiveValue:,completion:,failure:)`` operator’s `failure` closure indicates the failure and termination of the stream.
  ///
  ///     let myRange = (0...3)
  ///     cancellable = myRange.publisher
  ///         .sink(receiveValue: { print("value: \($0)") },
  ///               completion: { print("completion") },
  ///               failure: { print("failure: \($0)") })
  ///
  ///     // Prints:
  ///     //  value: 0
  ///     //  value: 1
  ///     //  value: 2
  ///     //  value: 3
  ///     //  completion
  ///
  /// This method creates the subscriber and immediately requests an unlimited number of values, prior to returning the subscriber.
  /// The return value should be held, otherwise the stream will be canceled.
  ///
  /// - parameter receiveValue: The closure to execute on receipt of a value.
  /// - parameter complete: The closure to execute on completion.
  /// - parameter failure: The closure to execute on failure.
  /// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
  public func sink(receiveValue: ((Self.Output) -> Void)? = nil, completion: (() -> Void)? = nil, failure: ((Self.Failure) -> Void)? = nil) -> AnyCancellable {
    self.sink(
      receiveCompletion: { receivedCompletion in
        switch receivedCompletion {
        case .finished:
          completion?()
        case .failure(let error):
          failure?(error)
        }
      },
      receiveValue: receiveValue ?? { _ in })
  }
  
  public func debug(_ label: String) -> AnyPublisher<Self.Output, Self.Failure> {
    self.handleEvents(
      receiveSubscription: { subscription in
        Swift.print("\(Date()) \(label) subscribed \(subscription)")
      },
      receiveOutput: { output in
        Swift.print("\(Date()) \(label) output \(output)")
      },
      receiveCompletion: { completion in
        Swift.print("\(Date()) \(label) completion \(completion)")
      },
      receiveCancel: {
        Swift.print("\(Date()) \(label) cancel")
      },
      receiveRequest: { demand in
        Swift.print("\(Date()) \(label) request \(demand)")
      })
      .eraseToAnyPublisher()
  }
  
  /// .withLatestFromFix(_:) in CombineExt is leaky for long-lived streams: https://github.com/CombineCommunity/CombineExt/issues/87
  /// This version fixes the stream issue (see comment on 8/6/2021 by freak4pc) https://gist.github.com/freak4pc/8d46ea6a6f5e5902c3fb5eba440a55c3
  func withLatestFromUnretained<Other: Publisher, Result>(_ other: Other, resultSelector: @escaping (Output, Other.Output) -> Result) -> AnyPublisher<Result, Failure> where Other.Failure == Failure {
    let upstream = share()
    return other
      .map { second in upstream.map { resultSelector($0, second) } }
      .switchToLatest()
      .zip(upstream) // `zip`ping and discarding `\.1` allows for
      // upstream completions to be projected down immediately.
      .map(\.0)
      .eraseToAnyPublisher()
  }
  
  /// .withLatestFromFix(_:) in CombineExt is leaky for long-lived streams: https://github.com/CombineCommunity/CombineExt/issues/87
  /// This version fixes the stream issue (see comment on 8/6/2021 by freak4pc) https://gist.github.com/freak4pc/8d46ea6a6f5e5902c3fb5eba440a55c3
  func withLatestFromUnretained<Other: Publisher>(_ other: Other) -> AnyPublisher<Other.Output, Other.Failure> where Failure == Other.Failure {
    let upstream = share()
    return other
      .map { second in upstream.map { _ in second  } }
      .switchToLatest()
      .zip(upstream) // `zip`ping and discarding `\.1` allows for
      // upstream completions to be projected down immediately.
      .map(\.0)
      .eraseToAnyPublisher()
  }
}

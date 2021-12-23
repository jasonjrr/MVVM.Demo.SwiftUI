//
//  AnyPublisher+AwaitResults.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 12/23/21.
//

import Foundation
import Combine
import CombineExt

public extension AnyPublisher {
    /// Buffers `count` events from the `Publisher` and returns them
    /// as an ordered array of `Result<Output, Failure>`. If there
    /// are no events to  buffer, `nil` is returned. If the `Publisher`
    /// errors, it will be reflected in the `Result`s.
    @available(iOS 15.0, *)
    func awaitResults(_ count: Int, scheduler: DispatchQueue = DispatchQueue.main) async -> [Result<Output, Failure>]? {
        let publisher: AnyPublisher<[Result<Output, Failure>], Never> = self
            .map {
                Result<Output, Failure>.success($0)
            }
            .catch {
                CurrentValueSubject(Result<Output, Failure>.failure($0)).eraseToAnyPublisher()
            }
            .collect(count)
            .timeout(5.0, scheduler: scheduler)
            .share(replay: 1)
            .eraseToAnyPublisher()
        
        var iterator = publisher.values.makeAsyncIterator()
        return await iterator.next()
    }
}

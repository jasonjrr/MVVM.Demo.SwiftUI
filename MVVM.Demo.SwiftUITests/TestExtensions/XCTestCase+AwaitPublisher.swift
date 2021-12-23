//
//  XCTestCase+AwaitPublisher.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 12/23/21.
//

import Foundation
import Combine
import XCTest

public extension XCTestCase {
    /// Buffers `count` events from `publisher` and returns them
    /// as an ordered array of `Result<Output, Failure>`. If there
    /// are no events to  buffer, `nil` is returned. If the `Publisher`
    /// errors, it will be reflected in the `Result`s.
    @available(iOS 15.0, *)
    func awaitPublisher<Output, Failure: Error>(_ publisher: AnyPublisher<Output, Failure>, count: Int, scheduler: DispatchQueue = DispatchQueue.main) async -> [Result<Output, Failure>]? {
        await publisher.awaitResults(count, scheduler: scheduler)
    }
}

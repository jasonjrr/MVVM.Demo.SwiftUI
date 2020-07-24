//
//  Publisher+DefinedScheduler.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

enum DefinedScheduler {
  case global(qos: DispatchQoS.QoSClass)
  case main
  case named(String)
  
  var dispatchQueue: DispatchQueue {
    switch self {
    case .global(let qos): return DispatchQueue.global(qos: qos)
    case .main: return DispatchQueue.main
    case .named(let name): return DispatchQueue(label: name)
    }
  }
}

extension Publisher {
  /// downstream
  func receive(on definedScheduler: DefinedScheduler) -> Publishers.ReceiveOn<Self, DispatchQueue> {
    self.receive(on: definedScheduler.dispatchQueue)
  }
  
  /// upstream
  func subscribe(on definedScheduler: DefinedScheduler) -> Publishers.SubscribeOn<Self, DispatchQueue> {
    self.subscribe(on: definedScheduler.dispatchQueue)
  }
  
  func debounce(for dueTime: DispatchQueue.SchedulerTimeType.Stride, on definedScheduler: DefinedScheduler) -> Publishers.Debounce<Self, DispatchQueue> {
    self.debounce(for: dueTime, scheduler: definedScheduler.dispatchQueue)
  }
  
  func throttle(for dueTime: DispatchQueue.SchedulerTimeType.Stride, on definedScheduler: DefinedScheduler, latest: Bool) -> Publishers.Throttle<Self, DispatchQueue> {
    self.throttle(for: dueTime, scheduler: definedScheduler.dispatchQueue, latest: latest)
  }
}

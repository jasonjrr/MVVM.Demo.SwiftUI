//
//  ColorService+Tests.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 2/28/22.
//

import Foundation
@testable import MVVM_Demo_SwiftUI
import XCTest
import Combine
import CombineExt
import SwiftUI

class ColorServiceTest: XCTestCase {
  var subject: ColorService!
  
  override func setUp() {
    super.setUp()
    self.subject = ColorService()
  }
}

class ColorService_when_getNextColor_is_called: ColorServiceTest {
  func test_then_colors_are_returned_in_expected_order() {
    let actualColors: [ColorModel] = [
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
      self.subject.getNextColor(),
    ]
    
    let expectedColors: [ColorModel] = [
      .blue,
      .green,
      .orange,
      .pink,
      .purple,
      .red,
      .yellow,
      .blue,
      .green,
      .orange,
    ]
    
    XCTAssertEqual(actualColors, expectedColors)
  }
}

class ColorService_when_generateNextColor_is_called: ColorServiceTest {
  var subscription: AnyCancellable?
  var values: [ColorModel] = []
   
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    self.subscription?.cancel()
  }
  
  func test_then_emitted_colors_are_expected() async {
    var iterator = self.subject
      .generateColors()
      .buffer(size: 10, prefetch: .keepFull, whenFull: .dropNewest)
      .flatMap(maxPublishers: .max(1)) { output in
        Just(output).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
      .values.makeAsyncIterator()
    
    for _ in 0..<10 {
      guard let color = await iterator.next() else {
        return
      }
      self.values.append(color)
    }
    
    XCTAssertEqual(values.count, 10)
    
    let possibleColors: [ColorModel] = [
      .blue,
      .green,
      .orange,
      .pink,
      .purple,
      .red,
      .yellow,
    ]
    
    values.forEach { color in
      XCTAssertTrue(possibleColors.contains(color))
    }
  }
}

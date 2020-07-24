//
//  PartyViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/23/20.
//

import Foundation
import Combine
import SwiftUI

protocol PartyViewModelDelegate: class {
    func partyViewModelOnDismiss(_ source: PartyViewModel)
}

class PartyViewModel: ViewModel {
    private let colorService: ColorService
    
    private weak var delegate: PartyViewModelDelegate?
    
    private var cancelBag: CancelBag = CancelBag()
    
    private(set) var colors: AnyPublisher<[ColorViewModel], Never>!
    
    init(colorService: ColorService) {
        self.colorService = colorService
        var colorIndex: Int = 0
        let getIndex: () -> Int = {
            let index = colorIndex
            colorIndex = colorIndex + 1
            return index
        }
        
        var colors: [ColorViewModel] = [ColorViewModel(index: getIndex(), color: colorService.getNextColor())]
        
        self.colors = Timer.publish(every: 0.75, on: .main, in: .default)
            .autoconnect()
            .map { _ in
                colors.append(ColorViewModel(index: getIndex(), color: colorService.getNextColor()))
                while colors.count > 7 {
                    colors.remove(at: 0)
                }
                return colors
            }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func setup(delegate: PartyViewModelDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    func onDismiss() {
        self.delegate?.partyViewModelOnDismiss(self)
    }
}

class ColorViewModel: ViewModel {
    let index: Int
    let color: Color
    
    init(index: Int, color: Color) {
        self.index = index
        self.color = color
    }
}

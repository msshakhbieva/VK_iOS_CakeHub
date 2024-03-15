//
//  TestNewMainModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 28.01.2024.
//

import Foundation

protocol TestNewMainViewControllerProtocol {

}

final class TestNewMainViewModel {
    var sections: [Section] = [.header]
}

// MARK: - Section

extension TestNewMainViewModel {
    
    /// Sections of the main view controller
    enum Section {
        case header
        case new([String])
        case sales([String])
        case all([String])
    }
}

extension TestNewMainViewModel.Section {

    var itemsCount: Int {
        switch self {
        case .header:
            return 1
        case .new(let items):
            return items.count
        case let .sales(items):
            return items.count
        case let .all(items):
            return items.count
        }
    }
}

extension TestNewMainViewModel: TestNewMainViewControllerProtocol {

}

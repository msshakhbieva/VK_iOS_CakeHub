//
//  MainViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - MainViewModelProtocol

protocol MainViewModelActionProtocol {
    func pressedProductCard(_ indexPath: IndexPath)
    func pressedCardBasket(_ cakeModel: CakeModel)
}

protocol MainViewModelNetworkProtocol {
    func fetchCakesList(completion: @escaping CHMResultBlock<Bool, APIError>)
}

// MARK: - MainViewModel

final class MainViewModel: ViewModelProtocol {

    private(set) var sections: [SectionKind] = []
    private var firebaseManager: FirebaseManager

    init(
        sections: [SectionKind] = [.categories(.shimmering), .cakes(.shimmering)],
        firebaseManager: FirebaseManager
    ) {
        self.sections = sections
        self.firebaseManager = firebaseManager
    }
}

// MARK: - SectionKind

extension MainViewModel {

    enum SectionKind {
        case categories([CategoryModel])
        case cakes([CakeModel])
    }
}

extension MainViewModel.SectionKind {

    var items: [any Identifiable] {
        switch self {
        case .categories(let categories):
            return categories
        case .cakes(let cakes):
            return cakes
        }
    }

    var sectionCount: Int {
        items.count
    }
}

// MARK: - Actions

extension MainViewModel: MainViewModelActionProtocol {

    /// Нажатие на карточку торта
    /// - Parameter indexPath: indexPath ячейки
    /// - Returns: Данные по нажатому торту
    func pressedProductCard(_ indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .categories(let catigories):
            print("Selected: \(String(describing: catigories[indexPath.item].title))")
        case .cakes(let products):
            print("Selected: \(products[indexPath.item].price ?? "Не укзана")")
        }
    }
    
    /// Нажатие на корзину торта
    /// - Parameter cakeModel: информация по торту
    func pressedCardBasket(_ cakeModel: CakeModel) {
        print("Заказан: \(cakeModel.price ?? "")")
    }
}

// MARK: - Network

extension MainViewModel: MainViewModelNetworkProtocol {

    func fetchCakesList(completion: @escaping CHMResultBlock<Bool, APIError>) {
        firebaseManager.cakeService.getCakesList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cakes):
                guard sections.count > 1 else {
                    completion(.success(false))
                    return
                }
                sections[0] = SectionKind.categories(.mockData)
                sections[1] = SectionKind.cakes(cakes)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

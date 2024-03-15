//
//  GoodsCreationViewControllerCoordinator.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

final class GoodsCreationViewControllerCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let vc = GoodsCreationViewController(viewModel: .mockData)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Routing

extension GoodsCreationViewControllerCoordinator {
    
    func openSummaryCakeViewController(cake: CakeModel) {
        let summaryCoordinator = SummaryCakeViewControllerCoordinator(
            navigationController: navigationController, 
            viewModel: SummaryCakeViewModel(cake: cake)
        )
        add(summaryCoordinator)
        summaryCoordinator.start()
    }
}

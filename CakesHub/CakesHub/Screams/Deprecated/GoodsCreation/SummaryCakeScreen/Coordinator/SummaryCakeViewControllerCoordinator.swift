//
//  SummaryCakeViewControllerCoordinator.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

final class SummaryCakeViewControllerCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private var viewModel: SummaryCakeViewModel
    
    init(navigationController: UINavigationController, viewModel: SummaryCakeViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    override func start() {
        let vc = SummaryCakeViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

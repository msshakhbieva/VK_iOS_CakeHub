//
//  MainViewControllerCoordinator.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

final class MainViewControllerCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let firebaseManager = FirebaseManager()
        let viewModel = MainViewModel(firebaseManager: firebaseManager)
        let vc = MainViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

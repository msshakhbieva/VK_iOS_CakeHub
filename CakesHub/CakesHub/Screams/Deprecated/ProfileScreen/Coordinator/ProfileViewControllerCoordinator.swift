//
//  ProfileViewControllerCoordinator.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

final class ProfileViewControllerCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let parentCoordinator: Coordinator
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        let vc = ProfileViewController(viewModel: .mockData)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Routering

extension ProfileViewControllerCoordinator {
    
    func openGoodsCreationScreen() {
        guard let coordinator = parentCoordinator as? CHMTabBarViewControllerCoordinator else { fatalError("Ошибка приведения типа") }
        coordinator.navigationController.setNavigationBarHidden(false, animated: false)
        coordinator.openGoodsCreationScreen()
    }
}

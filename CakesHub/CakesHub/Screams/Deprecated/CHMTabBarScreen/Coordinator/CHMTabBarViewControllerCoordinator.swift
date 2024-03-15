//
//  CHMTabBarViewControllerCoordinator.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

final class CHMTabBarViewControllerCoordinator: BaseCoordinator {
    
    let navigationController: UINavigationController
    private let viewModel = CHMTabBarViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let mainNavigation = UINavigationController()
        let notificationNavigation = UINavigationController()
        let profileNotification = UINavigationController()
        
        let mainCoordinator = MainViewControllerCoordinator(navigationController: mainNavigation)
        let notificationCoordinator = NotificationViewControllerCoordinator(navigationController: notificationNavigation)
        let profileCoordinator = ProfileViewControllerCoordinator(navigationController: profileNotification, parentCoordinator: self)
        
        let childCoordinators = [mainCoordinator, notificationCoordinator, profileCoordinator]
        addCoordinators(childCoordinators)
        
        viewModel.viewControllers = [
            .main(mainNavigation),
            .notifications(notificationNavigation),
            .profile(profileNotification)
        ]
        
        let tabBarController = CHMTabBarViewController(viewModel: viewModel)
        tabBarController.coordinator = self
        navigationController.pushViewController(tabBarController, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        childCoordinators.forEach { $0.start() }
    }
}

// MARK: - Routing

extension CHMTabBarViewControllerCoordinator {
    
    func openGoodsCreationScreen() {
        let coordinator = GoodsCreationViewControllerCoordinator(navigationController: navigationController)
        add(coordinator)
        coordinator.start()
    }
}

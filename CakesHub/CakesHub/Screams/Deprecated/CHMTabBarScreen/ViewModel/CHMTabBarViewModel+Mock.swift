//
//  CHMTabBarViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension CHMTabBarViewModel {
    
    static var mockData: CHMTabBarViewModel {
        let mainVC = UINavigationController(
            rootViewController: MainViewController(
                viewModel: MainViewModel(sections: .mockDataURL, firebaseManager: FirebaseManager())
            )
        )
        let notificationsVC = UINavigationController(
            rootViewController: NotificationViewController(viewModel: NotificationViewModel(), user: .mockData)
        )
        let profileVC = UINavigationController(rootViewController: ProfileViewController(viewModel: .mockData))
        
        let viewModel = CHMTabBarViewModel()
        viewModel.viewControllers = [
            .main(mainVC),
            .notifications(notificationsVC),
            .profile(profileVC)
        ]
        return viewModel
    }
}

//
//  CHMTabBarViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

// MARK: - CHMTabBarViewModelProtocol

protocol CHMTabBarViewModelProtocol: AnyObject {}

// MARK: - CHMTabBarViewModel

final class CHMTabBarViewModel: ViewModelProtocol {
    
    var viewControllers: [Screens] = []
    
    /// Экраны таббара
    enum Screens {
        case main(UIViewController)
        case notifications(UIViewController)
        case profile(UIViewController)
    }
}

// MARK: - Screens

extension CHMTabBarViewModel.Screens {
    
    /// View controller
    var viewController: UIViewController {
        switch self {
        case .main(let vc), .notifications(let vc), .profile(let vc):
            return vc
        }
    }
    
    /// Заголовок tabbarItem
    var title: String {
        switch self {
        case .main:
            return "Главная"
        case .notifications:
            return "Уведомления"
        case .profile:
            return "Профиль"
        }
    }
    
    /// Картинка tabbarItem
    var image: UIImage? {
        switch self {
        case .main:
            return .imgHome
        case .notifications:
            return .imgBell
        case .profile:
            return .imgPerson
        }
    }
}

// MARK: - Actions

extension CHMTabBarViewModel: CHMTabBarViewModelProtocol {}

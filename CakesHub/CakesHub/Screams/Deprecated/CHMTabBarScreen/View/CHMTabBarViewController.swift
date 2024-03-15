//
//  CHMTabBarViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class CHMTabBarViewController: UITabBarController, ViewModelable {
    
    // MARK: Coordinator
    
    weak var coordinator: CHMTabBarViewControllerCoordinator?
    
    // MARK: View Model
    
    var viewModel: CHMTabBarViewModel
    
    // MARK: Lifecycle
    
    init(viewModel: CHMTabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        appearanceTabBar()
    }
}

// MARK: - Private Methods

private extension CHMTabBarViewController {
    
    func setup() {
        viewControllers = viewModel.viewControllers.map {
            generateViewController(
                vc: $0.viewController,
                barTitle: $0.title,
                image: $0.image
            )
        }
    }
    
    func generateViewController(
        vc: UIViewController,
        barTitle: String,
        image: UIImage?
    ) -> UIViewController {
        vc.tabBarItem.title = barTitle
        vc.tabBarItem.image = image
        return vc
    }
    
    func appearanceTabBar() {
        tabBar.tintColor = UIColor.wild
        tabBar.unselectedItemTintColor = UIColor.secondary
        guard !UIDevice.isSe else { return }
        let x: CGFloat = 10
        let width = tabBar.bounds.width - x.doubling
        let height = tabBar.bounds.height + 10
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: x,
                y: -3,
                width: width,
                height: height
            ),
            cornerRadius: height
        )
        roundLayer.path = bezierPath.cgPath
        roundLayer.fillColor = UIColor.tabBarBackgroundColor.cgColor
        roundLayer.strokeColor = UIColor.tabBarStrokeColor.cgColor
        roundLayer.lineWidth = 1
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .clear
    }
}

// MARK: - Preview

#Preview {
    let vc = UINavigationController(
        rootViewController: CHMTabBarViewController(viewModel: .mockData)
    )
    vc.navigationBar.isHidden = true
    return vc
}

// MARK: - Constants

private extension UIColor {
    
    static var tabBarBackgroundColor = UIColor {
        $0.userInterfaceStyle == .light ? .white2 : .black
    }
    static let tabBarStrokeColor = UIColor.wild
}

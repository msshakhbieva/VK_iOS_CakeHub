//
//  CategoryViewCell.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class CategoryViewCell: UICollectionViewCell {

    static let identifier = String(describing: "\(CategoryViewCell.self)")

    private lazy var categoryView = CHMCategoryView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CategoryViewCell {

    func configuration(configuration: CHMCategoryView.Configuration, color: UIColor) {
        categoryView.configuration = configuration
        categoryView.layer.borderWidth = 1
        categoryView.layer.cornerRadius = 8
        categoryView.layer.borderColor = color.cgColor
    }
}

private extension CategoryViewCell {

    func setup() {
        addSubview(categoryView)
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryView.topAnchor.constraint(equalTo: topAnchor),
            categoryView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//
//  ProductCardCell.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class ProductCardCell: UICollectionViewCell {

    static let identifier = String(describing: "\(ProductCardCell.self)")

    private lazy var productCard = CHMProductCard().with {
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

extension ProductCardCell {

    func configuration(configuration: CHMProductCard.Configuration) {
        productCard.configuration = configuration
    }

    func pressedImage(handler: CHMIntBlock?) {
        productCard.handlerConfiguration.actionImageTapHandler = handler
    }

    func pressedBasket(handler: CHMVoidBlock?) {
        productCard.handlerConfiguration.actionBasketTapHandler = handler
    }
}

private extension ProductCardCell {

    func setup() {
        addSubview(productCard)
        NSLayoutConstraint.activate([
            productCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            productCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            productCard.topAnchor.constraint(equalTo: topAnchor),
            productCard.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

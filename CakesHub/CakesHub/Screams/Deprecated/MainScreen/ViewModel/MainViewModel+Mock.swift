//
//  MainViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension [MainViewModel.SectionKind] {

    static let mockDataImage: Self = [
        .categories(.mockData),
        .cakes(.mockDataImage)
    ]

    static let mockDataURL: Self = [
        .categories(.mockData),
        .cakes(.mockDataURL)
    ]
}

// MARK: - CategoryModel

extension [CategoryModel] {

    static let mockData: Self = [
        .init(
            imageURL: URL(string: "https://i.pinimg.com/originals/1b/f4/15/1bf415f09f25f9d033902fd043f5ebfd.jpg"), 
            title: "Свадебные",
            borderColor: UIColor.systemTeal
        ),
        .init(
            imageURL: URL(string: "https://mykaleidoscope.ru/x/uploads/posts/2022-10/1666333344_46-mykaleidoscope-ru-p-tortiki-s-dnem-rozhdeniya-otkritki-oboi-56.jpg"), 
            title: "День\nРождения",
            borderColor: UIColor.systemIndigo
        ),
        .init(
            imageURL: URL(string: "https://ae04.alicdn.com/kf/Se3950d8634e247e181dc31089dc053a53.jpg"), 
            title: "Хэлуин",
            borderColor: UIColor.danger
        ),
        .init(
            imageURL: URL(string: "https://ae04.alicdn.com/kf/H608ad674863e436b9caaf57c5693d2c5B.jpg"), 
            title: "Спорт",
            borderColor: UIColor.yellow
        )
    ]
}

extension [CategoryModel] {

    static let shimmering: Self = [
        .init(imageURL: nil, title: nil, borderColor: .systemTeal),
        .init(imageURL: nil, title: nil, borderColor: .systemIndigo),
        .init(imageURL: nil, title: nil, borderColor: .danger),
        .init(imageURL: nil, title: nil, borderColor: .yellow),
    ]
}

// MARK: - CakeModel

private extension [CakeModel] {

    static let mockDataImage: Self = (0...20).map {
        .init(
            id: "tMqq3tWoyTtkSisEi6pi",
            price: "\($0) $",
            description: "Качественный дорокущий торт \($0)\nЗаказывайте, не пожалеете! По возможности",
            images: .image(.images),
            seller: .mockData
        )
    }

    static let mockDataURL: Self = (1...20).map {
        .init(
            id: "tMqq3tWoyTtkSisEi6pi",
            price: "\($0)00 $",
            description: "Качественный дорокущий торт \($0)\nЗаказывайте, не пожалеете! По возможности",
            images: .url(.images.shuffled()),
            seller: .mockData
        )
    }
}

extension [CakeModel] {

    static let shimmering: Self = (0...20).map { CakeModel(id: "\($0)", images: .url([nil, nil])) }
}

// MARK: - Constants

private extension [URL?] {

    static let images: Self = [
        .mockCake1,
        .mockCake2,
        .mockCake3,
        .mockCake4
    ]
}

private extension [UIImage?] {

    static let images: Self = Array(repeating: UIImage(named: "cake"), count: 6)
}

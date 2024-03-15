//
//  CategoryModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

struct CategoryModel: Identifiable {
    let id = UUID()
    var imageURL: URL?
    var title: String?
    var borderColor: UIColor?
}

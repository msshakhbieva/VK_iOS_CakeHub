//
//  SummaryCakeViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

final class SummaryCakeViewModel: ViewModelProtocol {
    var cake: CakeModel

    init(cake: CakeModel) {
        self.cake = cake
    }
}

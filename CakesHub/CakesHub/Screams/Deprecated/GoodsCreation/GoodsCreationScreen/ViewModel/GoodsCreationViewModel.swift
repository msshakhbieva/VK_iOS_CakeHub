//
//  GoodsCreationViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

protocol GoodsCreationViewModelProtocol {
    func pressedContinue(completion: CHMBoolBlock)
    func pressedCard(_ index: Int) -> Bool
    func didFinishPickingMediaWithInfo(info: [UIImagePickerController.InfoKey : Any]) -> String?
    func pressedClose()
}

final class GoodsCreationViewModel: ViewModelProtocol {
    
    var cake: CakeModel
    /// Индексы карточек с фотографиями
    var selectedImages: Set<Int> = Set()
    /// Последняя нажатая карточка
    var selectedCardIndex: Int? = nil
    /// Карточки фотографий
    var cards: [(view: CHMAddingCakeView, img: UIImage?)] = []
    
    init(cake: CakeModel) {
        self.cake = cake
    }
}

// MARK: Actions

extension GoodsCreationViewModel: GoodsCreationViewModelProtocol {
    
    /// Пользователь выбрал фотографию из галереи
    /// - Parameter info: UIImagePickerController
    /// - Returns: текст с ошибкой
    func didFinishPickingMediaWithInfo(info: [UIImagePickerController.InfoKey : Any]) -> String? {
        guard
            let image = info[.originalImage] as? UIImage,
            let selectedCardIndex
        else {
            return "Ошибка чтения фотографии, повторить попытку"
        }
        cards[selectedCardIndex].view.configuration = .basic(
            .image(.image(image, placeholder: .cake))
        )
        cards[selectedCardIndex].img = image
        selectedImages.insert(selectedCardIndex)
        return nil
    }
    
    /// Нажатие карточки
    /// - Parameter index: индекс нажатой карты
    /// - Returns: Флажок, надо ли открывать фото пикер
    func pressedCard(_ index: Int) -> Bool {
        /// Если карточка уже была нажата, удаляем фото, иначе запоминаем нажатую карту и открываем фото пикер
        if selectedImages.contains(index) {
            // TODO: Добавить alert для уточнения, хотим ли удалить
            cards[index].view.configuration = .basic(.empty)
            cards[index].img = nil
            selectedImages.remove(index)
            return false
        }
        selectedCardIndex = index
        return true
    }
    
    
    /// Нажатие кнопки `продолжить`
    /// - Parameter completion: блок с флажком, открываем ли мы второй экран для ввода подробной информации
    func pressedContinue(completion: CHMBoolBlock) {
        /// Если введена цена и описание торта, тогда отправляем запрос в бд, иначе открываем экран ввода информации по торту
        guard
            let price = cake.price.emptyOrNilToString, let description = cake.description.emptyOrNilToString
        else {
            completion(true)
            return
        }
        
        let filteredPhotos = cards.compactMap { $0.img }
        cake.images = .image(filteredPhotos)
        /* Тут будем что-то действие для реализации создания торта */
        print("Создан торт: \(price), \(description), \(cake.images.count) шт")
        completion(false)
    }
    
    func pressedClose() {
        cake.price = nil
        cake.description = nil
    }
}

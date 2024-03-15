//
//  ProfileViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

protocol ProfileViewModelProtocol: AnyObject {
    func pressedProfileButton(_ selectedButton: CHMIconTextView) -> ProfileViewModel.Screens
    func didFinishPickingMediaWithInfo(info: [UIImagePickerController.InfoKey : Any]) -> UIImage?
}

final class ProfileViewModel: ViewModelProtocol {
    
    var user: UserModel
    var screens: [Screens] = []
    private(set) var buttons: [CHMIconTextView.Configuration] = []
    
    init(user: UserModel) {
        self.user = user
        buttons = .buttons
    }
}

// MARK: - Router

extension ProfileViewModel {
    
    /// Destination screens
    enum Screens: String {
        case editProfile = "Редактировать профиль"
        case location = "Локация"
        case announcement = "Выложить торт на продажу"
        case feedback = "Feedback"
        case logout = "Выйти"
    }
}

// MARK: - Actions

extension ProfileViewModel: ProfileViewModelProtocol {
    
    /// Пользователь нажал кнопку перехода на экран
    /// - Parameter selectedButton: нажатая кнопка
    /// - Returns: эран назначения
    func pressedProfileButton(_ selectedButton: CHMIconTextView) -> Screens {
        let buttonTitle = selectedButton.configuration.titleConfiguration.labelConfiguration.attributedString.string
        guard let screens = Screens(rawValue: buttonTitle) else { fatalError("Для всех экранов должны быть кнопки") }
        return screens
    }
    
    /// Пользователь выбрал фотографию из галереи
    /// - Parameter info: UIImagePickerController
    /// - Returns: текст с ошибкой
    func didFinishPickingMediaWithInfo(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        guard let image = info[.originalImage] as? UIImage else { return nil }
        loadImageToTheServer(image: image)
        return image
    }
}

// MARK: - Methods

extension ProfileViewModel {
    
    /// Computed full name
    var userFullName: String {
        guard !user.name.isNil && !user.surname.isNil else { return "Анонинмный пользователь" }
        return (user.name ?? .clear) + .space + (user.surname ?? .clear)
    }
    
    /// Загрузка картинки на сервер
    /// - Parameter image: выбранная фотография из галереи
    func loadImageToTheServer(image: UIImage) {
        // TODO: Добавить логику с загрузкой в облако
    }
}

// MARK: - Constants

private extension [CHMIconTextView.Configuration] {
    
    static var buttons: Self = [
        .basic(title: ProfileViewModel.Screens.editProfile.rawValue, imageKind: .profile),
        .basic(title: ProfileViewModel.Screens.location.rawValue, imageKind: .location),
        .basic(title: ProfileViewModel.Screens.announcement.rawValue, imageKind: .announcement),
        .basic(title: ProfileViewModel.Screens.feedback.rawValue, imageKind: .feedback),
        .logout(title: ProfileViewModel.Screens.logout.rawValue)
    ]
}

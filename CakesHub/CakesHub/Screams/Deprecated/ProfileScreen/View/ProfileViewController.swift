//
//  ProfileViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class ProfileViewController: UIViewController, ViewModelable {

    // MARK: Coordinator

    weak var coordinator: ProfileViewControllerCoordinator?

    // MARK: View Model

    var viewModel: ProfileViewModel

    // MARK: Subviews

    private lazy var imagePicker = UIImagePickerController().with {
        $0.sourceType = .photoLibrary
        $0.delegate = self
    }
    private lazy var scrollView = UIScrollView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alwaysBounceHorizontal = false
        $0.addSubviews(profileView, profileBlock)
    }
    private lazy var profileView = CHMProfileTopView(
        configuration: .basic(
            imageKind: .url(viewModel.user.imageURL),
            userName: viewModel.userFullName,
            nickname: viewModel.user.nickname,
            phone: viewModel.user.phone
        )
    ) .with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.handlerConfiguration.imageTapHandler = { [unowned self] in
            pressedAvatarView()
        }
    }
    private lazy var profileBlock = CHMProfileButtonsBlock(
        configuration: .basic(configurations: viewModel.buttons)
    ).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.handlerConfiguration.imageTapHandler = { [unowned self] button in
            pressedProfileBlock(button)
        }
    }

    // MARK: Lifecycle

    init(viewModel: ProfileViewModel) {
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
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Private Methods

private extension ProfileViewController {

    func setup() {
        view.backgroundColor = .whiteBlack
        navigationController?.navigationBar.isHidden = true
        view.addSubview(scrollView)
        makeConstraints()
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            profileView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .hPadding),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.hPadding),

            profileBlock.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: .containerTopPadding),
            profileBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .hPadding),
            profileBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.hPadding),
            profileBlock.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: - Actions

private extension ProfileViewController {

    /// Нажатие на кнопку
    /// - Parameter button: button with configuration
    func pressedProfileBlock(_ button: CHMIconTextView) {
        switch viewModel.pressedProfileButton(button) {
        case .editProfile:
            print("Открываем редактирование")
        case .feedback:
            print("Открываем feedback")
        case .location:
            print("Открываем location")
        case .announcement:
            coordinator?.openGoodsCreationScreen()
        case .logout:
            print("Открываем logout")
        }
    }

    /// Нажатие на аватарку
    func pressedAvatarView() {
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let image = viewModel.didFinishPickingMediaWithInfo(info: info)
        profileView.configuration = modify(profileView.configuration) { conf in
            conf.avatarViewConfiguration = modify(conf.avatarViewConfiguration) {
                $0.imageViewConfiguration = .basic(
                    .image(image, placeholder: .profile),
                    imageKind: .capsule
                )
            }
        }

        dismiss(animated: true)
    }
}

// MARK: - Preview

#Preview {
    UINavigationController(
        rootViewController: ProfileViewController(viewModel: .mockData)
    )
}

// MARK: - Constants

private extension CGFloat {

    static let hPadding: CGFloat = 16
    static let containerTopPadding: CGFloat = 54
}

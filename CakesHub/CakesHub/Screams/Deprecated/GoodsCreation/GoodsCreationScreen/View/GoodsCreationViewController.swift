//
//  GoodsCreationViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class GoodsCreationViewController: UIViewController, ViewModelable {
    
    // MARK: Coordinator
    
    weak var coordinator: GoodsCreationViewControllerCoordinator?
    
    // MARK: View Model
    
    var viewModel: GoodsCreationViewModel
    
    // MARK: Subviews
    
    private lazy var imagePicker = UIImagePickerController().with {
        $0.sourceType = .photoLibrary
        $0.delegate = self
    }
    private lazy var containerView = UIView().with {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var continueButton = CHMButton(
        configuration: .basic(kind: .cake, title: .continueTitle)
    ).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.handlerConfiguration.viewTapHandler = { [weak self] in
            guard let self else { return }
            pressedContinue()
        }
        $0.isHidden = true
    }
    private lazy var editButton = CHMButton(
        configuration: .basic(kind: .cakeBordered, title: "Редактировать")
    ).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.handlerConfiguration.viewTapHandler = { [weak self] in
            guard let self else { return }
            pressedEdit()
        }
        $0.isHidden = true
    }
    
    // MARK: Life cycle
    
    init(viewModel: GoodsCreationViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Setup

private extension GoodsCreationViewController {
    
    func setup() {
        view.backgroundColor = .whiteBlack
        setupNavigationTitle()
        view.addSubviews(containerView, continueButton, editButton)
        cardBlockContraints()
        continueButtonContraints()
    }
    
    func setupNavigationTitle() {
        title = .title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Добавляем блок фотографий
    func cardBlockContraints() {
        let width = (view.bounds.width - .containerPadding.doubling - (.numberСardsOnScreen - 1) * .cardsSpacing) / .numberСardsOnScreen
        
        ClosedRange.cardIteration.forEach { index in
            let cardView = CHMAddingCakeView(
                configuration: .basic(.empty)
            )
            cardView.handlerConfiguration.actionCardTapHandler = { [weak self] in
                guard let self else { return }
                pressedCard(index)
            }
            cardView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(cardView)
            
            let indexMoreThanThree = index >= 3
            let indexModeThree = index % 3 == 0
            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(
                    equalTo: indexMoreThanThree
                    ? viewModel.cards[index - 3].view.bottomAnchor
                    : containerView.topAnchor,
                    constant: indexMoreThanThree ? .cardsSpacing : .zero
                ),
                cardView.leadingAnchor.constraint(
                    equalTo: indexModeThree
                    ? containerView.leadingAnchor
                    : viewModel.cards[index - 1].view.trailingAnchor,
                    constant: indexModeThree ? .zero : .cardsSpacing
                ),
                cardView.widthAnchor.constraint(equalToConstant: width),
                cardView.heightAnchor.constraint(equalToConstant: 151),
            ])
            
            viewModel.cards.append((cardView, nil))
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .containerPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.containerPadding),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
    }
    
    func continueButtonContraints() {
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .containerPadding),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.containerPadding),
            continueButton.heightAnchor.constraint(equalToConstant: .nextButtonHeight),
            continueButton.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: .nextButtonBottomPadding),
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .containerPadding),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.containerPadding),
            editButton.heightAnchor.constraint(equalToConstant: .nextButtonHeight),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .nextButtonBottomPadding),
        ])
    }
}

// MARK: - Actions

private extension GoodsCreationViewController {
    
    /// Нажатие карточки
    /// - Parameter index: индекс нажатой карты
    func pressedCard(_ index: Int) {
        if viewModel.pressedCard(index) {
            present(imagePicker, animated: true)
        } else {
            continueButton.isHidden = viewModel.selectedImages.isEmpty
        }
        
    }
    
    /// Нажатие кнопки  `продолжить`
    func pressedContinue() {
        viewModel.pressedContinue { showSummaryVC in
            if showSummaryVC {
                openAddingGoodVC()
            } else {
                coordinator?.openSummaryCakeViewController(cake: viewModel.cake)
            }
        }
    }
    
    /// Нажатие кнопки `редактировать`
    func pressedEdit() {
        openAddingGoodVC()
    }
    
    func openAddingGoodVC() {
        let vc = AdditingGoodDescriptionViewController(viewModel: viewModel)
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - GoodsCreationViewController

extension GoodsCreationViewController: OutputAdditingGoodDescriptionDelegate {
    
    func getCakeInfo(price: String?, description: String?) {
        viewModel.cake.price = price
        viewModel.cake.description = description
        
        /// Меняем тайтл кнопки, если получили
        if !viewModel.cake.price.isEmptyOrNil && !viewModel.cake.description.isEmptyOrNil {
            continueButton.configuration = .basic(kind: .cake, title: "Создать")
            editButton.isHidden = false
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension GoodsCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /// Если получили текст ошибки, вызываем алерт
        if let errorStr = viewModel.didFinishPickingMediaWithInfo(info: info) {
            print(errorStr)
            // TODO: Вызвать алерт
            return
        }
        continueButton.isHidden = false
        dismiss(animated: true)
    }
}

// MARK: - Preview

#Preview {
    UINavigationController(
        rootViewController: GoodsCreationViewController(viewModel: .mockData)
    )
}

// MARK: - Constants

private extension String {
    
    static let title = "Создание торта"
    static let continueTitle = "Продолжить"
}

private extension CGFloat {
    
    static let containerPadding: CGFloat = 28
    static let cardsSpacing: CGFloat = 8
    static let numberСardsOnScreen: CGFloat = 3
    static let nextButtonHeight: CGFloat = 50
    static let nextButtonBottomPadding: CGFloat = -10
}

private extension (ClosedRange<Int>) {
    
    static let cardIteration = (0...5)
}

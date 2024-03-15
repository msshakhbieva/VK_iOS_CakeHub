//
//  MainViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class MainViewController: UIViewController, ViewModelable {

    // MARK: Coordinator

    weak var coordinator: MainViewControllerCoordinator?

    // MARK: View Model

    var viewModel: MainViewModel

    // MARK: Private UI Properties

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionViewCell.defaultIdentifier
        )
        collectionView.register(
            ProductCardCell.self,
            forCellWithReuseIdentifier: ProductCardCell.identifier
        )
        collectionView.register(
            CategoryViewCell.self,
            forCellWithReuseIdentifier: CategoryViewCell.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
}

// MARK: - MainViewController Setup

private extension MainViewController {

    func setup() {
        view.backgroundColor = .whiteBlack
        setupNavigationController()
        setupCollectionView()
    }

    func setupNavigationController() {
        title = String.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - Actions

private extension MainViewController {

    func pressedProductCard(_ indexPath: IndexPath) {
        viewModel.pressedProductCard(indexPath)
    }

    func pressedCardBasket(_ cakeModel: CakeModel) {
        let alertController = UIAlertController(
            title: .alertTitle,
            message: .alertPrice(cakeModel.price),
            preferredStyle: .alert
        )
        let receiveAction = UIAlertAction(title: .receiveAction, style: .default) { [weak self] _ in
            guard let self else { return }
            viewModel.pressedCardBasket(cakeModel)
        }
        let discardAction = UIAlertAction(title: .discardAction, style: .cancel)
        alertController.addAction(receiveAction)
        alertController.addAction(discardAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension MainViewController {

    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            switch viewModel.sections[sectionIndex] {
            case .categories:
                return createCatigoriesLayout
            case .cakes:
                return createProductsLayout
            }
        }
        let conf = UICollectionViewCompositionalLayoutConfiguration()
        conf.interSectionSpacing = 40
        layout.configuration = conf
        return layout
    }

    var createCatigoriesLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(130)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 5)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(130)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return section
    }

    var createProductsLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.45)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)

        return section
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.sections[section].sectionCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .categories(let catigories):
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryViewCell.identifier,
                    for: indexPath
                ) as? CategoryViewCell
            else {
                return collectionView.defaultCell(indexPath)
            }
            let data = catigories[indexPath.item]
            cell.configuration(
                configuration: .basic(data.imageURL, title: .clear),
                color: data.borderColor ?? .clear
            )
            return cell

        case .cakes(let products):
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCardCell.identifier,
                    for: indexPath
                ) as? ProductCardCell
            else {
                return collectionView.defaultCell(indexPath)
            }
            let data = products[indexPath.item]
            cell.configuration(
                configuration: .basic(
                    price: .price(price: data.price),
                    seller: data.seller?.name ?? .emptyName,
                    description: data.description ?? .emptyDescription,
                    images: data.images.productImages
                )
            )

            cell.pressedImage { [weak self] _ in
                guard let self else { return }
                pressedProductCard(indexPath)
            }
            cell.pressedBasket { [weak self] in
                guard let self else { return }
                pressedCardBasket(data)
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        pressedProductCard(indexPath)
    }
}

// MARK: - Network

private extension MainViewController {

    func fetchData() {
        viewModel.fetchCakesList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let flag):
                if flag {
                    collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Constants

private extension String {

    static let navigationTitle = "Тортики"
    static let emptyName = "Имя не задано"
    static let receiveAction = "Заказать"
    static let discardAction = "Отмена"
    static let emptyDescription = "Описание отсутствует"
    static let alertTitle = "Вы уверены, что хотите заказать этот торт"
    static func price(price: String?) -> String {
        guard let price else { return "Цена не назначена" }
        return price + " ₽"
    }
    static func alertPrice(_ price: String?) -> String {
        "Цена: " + .price(price: price)
    }
}

// MARK: - Preview

#Preview {
    UINavigationController(
        rootViewController: MainViewController(
            viewModel: MainViewModel(firebaseManager: FirebaseManager())
        )
    )
}

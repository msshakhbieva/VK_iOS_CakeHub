//
//  TestNewMainViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 28.01.2024.
//

import UIKit

final class TestNewMainViewController: UIViewController {

    // MARK: View Model

    private var viewModel: TestNewMainViewModel

    // MARK: Subviews

    private lazy var collectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.register(TestNewMainHeaderCell.self, forCellWithReuseIdentifier: TestNewMainHeaderCell.identifier)
        $0.contentInsetAdjustmentBehavior = .never
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: createLayout()))

    // MARK: - Lifycycle

    init(viewModel: TestNewMainViewModel) {
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
}

// MARK: - Setup

private extension TestNewMainViewController {

    func setup() {
        collectionView.backgroundColor = .blue
        view.addSubview(collectionView)
        makeConstraints()
    }

    func makeConstraints() {
        collectionViewConstraints()
    }

    func collectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Collection Layout

private extension TestNewMainViewController {

    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            switch viewModel.sections[sectionIndex] {
            case .header:
                return createHeaderCategoryLayout
            case .new:
                return createHeaderCategoryLayout //createNewCategoryLayout
            case .sales:
                return createHeaderCategoryLayout //createSalesCategoryLayout
            case .all:
                return createHeaderCategoryLayout //createAllCategoryLayout
            }
        }
//        let conf = UICollectionViewCompositionalLayoutConfiguration()
//        conf.interSectionSpacing = 40
//        layout.configuration = conf
        return layout
    }

    var createHeaderCategoryLayout: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(134/203)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

//    var createNewCategoryLayout: NSCollectionLayoutSection {
//
//    }
//
//    var createSalesCategoryLayout: NSCollectionLayoutSection {
//
//    }
//
//    var createAllCategoryLayout: NSCollectionLayoutSection{
//
//    }
}

extension TestNewMainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections[section].itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .header:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TestNewMainHeaderCell.identifier,
                    for: indexPath
                ) as? TestNewMainHeaderCell
            else {
                fatalError("Что-то пошло не так")
            }
            cell.configure(configuration: .mockConfiguration)
            return cell
//        case .new(_):
//        case .sales(_):
//        case .all(_):
        default:
            return UICollectionViewCell()
        }
    }
    

}

// MARK: - Preview

#Preview {
    TestNewMainViewController(viewModel: TestNewMainViewModel())
}

import CHMUIKIT
import SwiftUI

private extension CHMBigBannerView.Configuration {

    static let mockConfiguration: Self = .basic(
        imageKind: .image(Image("Big Banner")),
        bannerTitle: "Fashion\nsale",
        buttonTitle: "Check"
    )
}

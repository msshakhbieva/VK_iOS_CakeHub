//
//  SummaryCakeViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 12/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

final class SummaryCakeViewController: UIViewController {
    
    // MARK: Coordinator
    
    weak var coordinator: SummaryCakeViewControllerCoordinator?

    // MARK: View model

    private var viewModel: SummaryCakeViewModel!

    // MARK: Subviews
    
    private lazy var scrollView = UIScrollView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var caruoselView = CHMProductCarouselView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var priceLabel = CHMLabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var descriptionLabel = CHMLabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Life cycle

    init(viewModel: SummaryCakeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        caruoselView.configuration = .carouselConf(viewModel.cake.images.getUIImages ?? [])
        priceLabel.configuration = .labelConf(viewModel.cake.price)
        descriptionLabel.configuration = .descriptionLabelConf(viewModel.cake.description)
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Setup

private extension SummaryCakeViewController {

    func setup() {
        view.backgroundColor = .whiteBlack
        setupNavigationTitle()
        view.addSubview(scrollView)
        scrollView.addSubviews(
            caruoselView,
            descriptionLabel,
            priceLabel
        )
        addConstraintScrollView()
        addConstraintCarousel()
        addConstraintDescription()
        addConstraintPriceLabel()
    }

    func setupNavigationTitle() {
        title = .navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
    }

    func addConstraintScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func addConstraintCarousel() {
        NSLayoutConstraint.activate([
            caruoselView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            caruoselView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .padding),
            caruoselView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.padding),
            caruoselView.heightAnchor.constraint(equalToConstant: .caruoselHeight)
        ])
    }

    func addConstraintDescription() {
        let divider = generateDivider()
        let descriptionTitle = generateTitle(.descriptionTitle)
        scrollView.addSubviews(divider, descriptionTitle)

        NSLayoutConstraint.activate([
            descriptionTitle.topAnchor.constraint(equalTo: caruoselView.bottomAnchor, constant: .descriptionTopPadding),
            descriptionTitle.leadingAnchor.constraint(equalTo: caruoselView.leadingAnchor),
            descriptionTitle.trailingAnchor.constraint(equalTo: caruoselView.trailingAnchor),

            divider.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: .dividerPadding),
            divider.leadingAnchor.constraint(equalTo: caruoselView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: caruoselView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: .dividerPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: caruoselView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: caruoselView.trailingAnchor),
        ])
    }

    func addConstraintPriceLabel() {
        let divider = generateDivider()
        let priceTitle = generateTitle(.priceTitle)
        scrollView.addSubviews(divider, priceTitle)

        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .dividerPadding),
            divider.leadingAnchor.constraint(equalTo: caruoselView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: caruoselView.trailingAnchor),

            priceTitle.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: .dividerPadding),
            priceTitle.leadingAnchor.constraint(equalTo: caruoselView.leadingAnchor),
            priceTitle.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: .priceBottomTitle),

            priceLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: .dividerPadding),
            priceLabel.leadingAnchor.constraint(equalTo: priceTitle.trailingAnchor, constant: .priceLabelPadding),
            priceLabel.trailingAnchor.constraint(equalTo: caruoselView.trailingAnchor),
        ])
    }
}

// MARK: - Generate view

private extension SummaryCakeViewController {

    func generateTitle(_ title: String) -> UIView {
        CHMLabel(
            configuration: .custom(
                title,
                titleStyle: .semibold17,
                textColor: .primary
            )
        ).with {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - CHMLabel configuration

private extension CHMLabel.Configuration {

    static func labelConf(_ title: String?) -> Self {
        .custom(
            (title ?? .clear) + .space + .rub,
            titleStyle: .semibold19,
            textColor: .primary,
            alignment: .right
        )
    }

    static func descriptionLabelConf(_ text: String?) -> Self {
        .custom(
            text ?? .clear,
            titleStyle: .regular13,
            textColor: .secondary,
            lineBreak: .byClipping
        )
    }
}

// MARK: - CHMProductCarouselView configuration

private extension CHMProductCarouselView.Configuration {

    // FIXME: Добавить логику с UIImage а не URL
    static func carouselConf(_ images: [UIImage?]) -> Self {
        .basic(.image(images))
    }
}

// MARK: - Constants

private extension CGFloat {

    static let descriptionTopPadding: CGFloat = 20
    static let padding: CGFloat = 30
    static let dividerPadding: CGFloat = 10
    static let caruoselHeight: CGFloat = 226
    static let priceBottomTitle: CGFloat = -30
    /// Padding between price title and price label
    static let priceLabelPadding: CGFloat = 6
}

private extension String {

    static let navigationTitle = "Итог"
    static let descriptionTitle = "Описание"
    static let priceTitle = "Цена"
}

// MARK: - Preview

#Preview {
    UINavigationController(
        rootViewController: SummaryCakeViewController(viewModel: .mockData)
    )
}

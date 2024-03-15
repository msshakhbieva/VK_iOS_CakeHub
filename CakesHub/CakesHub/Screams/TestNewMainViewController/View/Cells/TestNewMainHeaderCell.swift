//
//  TestNewMainHeaderCell.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 28.01.2024.
//

import UIKit
import CHMUIKIT
import SwiftUI

final class TestNewMainHeaderCell: UICollectionViewCell {

    static let identifier = String(describing: "\(TestNewMainHeaderCell.self)")

    var model = CHMBigBannerView.ObservedConfiguration()
    private lazy var swiftUIBannerView = CHMBigBannerView(model: model)
    private var bannerView: UIView! = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    #if DEBUG
    init(configuration: CHMBigBannerView.Configuration) {
        super.init(frame: .zero)
        setup()
        model.configuration = configuration
    }
    #endif

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let hostingViewController = UIHostingController(rootView: swiftUIBannerView)
        guard let uiView = hostingViewController.view else { fatalError("Что-то пошло не так") }
        bannerView = uiView
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(configuration: CHMBigBannerView.Configuration) {
        model.configuration = configuration
    }
}

// MARK: - Preview

#Preview {
    SwiftUIPreview {
        TestNewMainHeaderCell(configuration: .basic(
            imageKind: .image(Image("Big Banner")),
            bannerTitle: "Fashion\nsale",
            buttonTitle: "Check"
        ))
    }
    .frame(width: 376, height: 536)
}

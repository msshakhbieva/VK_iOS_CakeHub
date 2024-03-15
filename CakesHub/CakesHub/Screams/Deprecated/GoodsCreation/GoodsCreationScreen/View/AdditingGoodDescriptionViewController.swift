//
//  AdditingGoodDescriptionViewController.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 12/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit
import CHMUIKIT

protocol OutputAdditingGoodDescriptionDelegate: AnyObject {
    
    func getCakeInfo(price: String?, description: String?)
}

final class AdditingGoodDescriptionViewController: UIViewController, ViewModelable {
    
    weak var delegate: OutputAdditingGoodDescriptionDelegate?
    
    // MARK: View Model
    
    var viewModel: GoodsCreationViewModel
    
    // MARK: Constraints
    
    private var bottomAnchor: NSLayoutConstraint!
    
    // MARK: Subviews
    
    private lazy var containerView = UIView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubviews(priceLabel, priceTF)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 4
    }
    private lazy var descriptionContainerView = UIView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubviews(desctiptionLabel, textView)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = .descriptionContainerRadius
    }
    private lazy var priceLabel = CHMLabel(
        configuration: .custom(
            .priceLabel,
            titleStyle: .regular13,
            textColor: .secondary
        )
    ).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var desctiptionLabel = CHMLabel(
        configuration: .custom(
            .descriptionLabel,
            titleStyle: .regular13,
            textColor: .secondary
        )
    ).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var textView = UITextView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.dataDetectorTypes = [.link, .phoneNumber]
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.wild
        ]
        $0.textContainerInset = UIEdgeInsets(top: .priceTFTopPadding, left: 8, bottom: 8, right: 8)
        $0.allowsEditingTextAttributes = true
        $0.delegate = self
        $0.returnKeyType = UIReturnKeyType.done
        $0.text = viewModel.cake.description
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.lightGrayDarkGray.cgColor
    }
    private lazy var priceTF = UITextField().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.attributedPlaceholder = NSAttributedString(
            string: .placeholderPrice,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.secondary
            ]
        )
        $0.textColor = .primary
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.keyboardType = .numberPad
        $0.text = viewModel.cake.price
    }
    private lazy var clearImageView = UIButton(type: .system).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(.clearLabel, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(tapClear), for: .touchUpInside)
        $0.tintColor = .primary
    }
    private lazy var saveLabel = UIButton(type: .system).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(.saveLabel, for: .normal)
        $0.tintColor = .wild
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
    }
    
    // MARK: Lifecycle
    
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
        setKeyboardNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.getCakeInfo(price: priceTF.text, description: textView.text)
    }
}

// MARK: - Setup

private extension AdditingGoodDescriptionViewController {
    
    func setup() {
        view.backgroundColor = .whiteBlack
        view.addSubviews(
            clearImageView,
            saveLabel,
            containerView,
            descriptionContainerView
        )
        addConstraintsCloseBar()
        addConstraintsTextField()
        addConstraintsTextView()
        
    }
    
    func addConstraintsCloseBar() {
        NSLayoutConstraint.activate([
            clearImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .closeBarPadding),
            clearImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .closeBarPadding),
            
            saveLabel.topAnchor.constraint(equalTo: clearImageView.topAnchor),
            saveLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.closeBarPadding),
        ])
    }
    
    func addConstraintsTextField() {
        let divider = generateDivider()
        containerView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: clearImageView.bottomAnchor, constant: .containerViewTopPadding),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .labelPadding),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.labelPadding),
            priceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .priceLabelTopPadding),
            
            priceTF.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: .priceTFTopPadding),
            priceTF.heightAnchor.constraint(equalToConstant: .priceTFHeight),
            priceTF.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .labelPadding),
            priceTF.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.labelPadding),
            priceTF.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .priceTFBottomPadding),
        ])
    }
    
    func addConstraintsTextView() {
        bottomAnchor = descriptionContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        NSLayoutConstraint.activate([
            descriptionContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .descriptionContainerViewTopPadding),
            descriptionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            desctiptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: .labelPadding),
            desctiptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .labelPadding),
            desctiptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.labelPadding),
            
            textView.topAnchor.constraint(equalTo: desctiptionLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .textViewPadding),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.textViewPadding),
            textView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor),
            bottomAnchor
        ])
    }
    
    func setKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Actions

private extension AdditingGoodDescriptionViewController {
    
    @objc
    func pressedSaveButton() {
        dismiss(animated: true)
    }
    
    @objc
    func tapClear() {
        textView.text = .clear
        priceTF.text = .clear
        viewModel.pressedClose()
    }
    
    
    @objc
    func keyboardWillShow(_ nc: NSNotification) {
        if let keyboardSize = (nc.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomAnchor.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc 
    func keyboardWillHide(_ nc: NSNotification) {
        bottomAnchor.constant = .zero
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate

extension AdditingGoodDescriptionViewController: UITextFieldDelegate {
    
    func textField(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        priceTF.text != .clear || text != "0"
    }
}

// MARK: - UITextViewDelegate

extension AdditingGoodDescriptionViewController : UITextViewDelegate {}

// MARK: - Preview

#Preview {
    AdditingGoodDescriptionViewController(viewModel: .mockData)
}

// MARK: - Useless

private extension AdditingGoodDescriptionViewController {
    
    func scrollToTop() {
        textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let closeBarPadding: CGFloat = 16
    static let descriptionContainerRadius: CGFloat = 4
    static let textViewPadding: CGFloat = 6
    static let labelPadding: CGFloat = 16
    static let priceLabelTopPadding: CGFloat = 10.13
    static let priceTFTopPadding: CGFloat = 6
    static let priceTFHeight: CGFloat = 22
    static let descriptionContainerViewTopPadding: CGFloat = 6
    static let containerViewTopPadding: CGFloat = 16
    static let priceTFBottomPadding: CGFloat = -9.91
}

private extension String {
    
    static let saveLabel = "Сохранить"
    static let clearLabel = "Очистить"
    static let placeholderPrice = "0"
    static let priceLabel = "Введите цену торта (руб)"
    static let descriptionLabel = "Введите описание торта"
}

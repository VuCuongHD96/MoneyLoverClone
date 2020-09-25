//
//  NumericKeyboard.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/25/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class DigitButton: UIButton {
    var digit: Int = 0
}

class NumericKeyboard: UIView {
    struct Constant {
        static let font = UIFont.preferredFont(forTextStyle: .title1)
        static let titleColor = UIColor.white
        static let borderColor = UIColor.gray.cgColor
        static let borderWidth: CGFloat = 0.5
    }
    weak var target: UIKeyInput?
    typealias Handler = () -> Void
    var doneEdit: Handler?

    var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = Constant.font
        button.setTitleColor(Constant.titleColor, for: .normal)
        button.layer.borderWidth = Constant.borderWidth
        button.layer.borderColor = Constant.borderColor
        button.accessibilityTraits = [.button]
        button.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
        return button
    }

    var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(Constant.titleColor, for: .normal)
        button.layer.borderWidth = Constant.borderWidth
        button.layer.borderColor = Constant.borderColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        return button
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(Constant.titleColor, for: .normal)
        button.layer.borderWidth = Constant.borderWidth
        button.layer.borderColor = Constant.borderColor
        button.accessibilityTraits = [.keyboardKey]
        button.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        return button
    }()

    init(target: UIKeyInput) {
        self.target = target
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension NumericKeyboard {
    @objc func didTapDigitButton(_ sender: DigitButton) {
        target?.insertText("\(sender.digit)")
    }

    @objc func didTapDoneButton(_ sender: DigitButton) {
        doneEdit?()
    }

    @objc func didTapDeleteButton(_ sender: DigitButton) {
        target?.deleteBackward()
    }
}

// MARK: - Private initial configuration methods

private extension NumericKeyboard {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }

    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)

        for row in (0 ..< 3).reversed() {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            for column in 0 ..< 3 {
                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
            }
        }

        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        subStackView.addArrangedSubview(doneButton)
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)
    }

    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}

//
//  OTPTextField.swift
//
//
//  Created by Ahmed Yamany on 23/04/2024.
//

import UIKit
import Combine


@available(iOS 14.0, *)
public protocol OTPTextFieldDataSource: AnyObject {
    func numberOfSlots(in otpTextField: OTPTextField) -> Int
    func otpTextField(_ otpTextField: OTPTextField, defaultCharacterInSlot slot: Int) -> String?
    func otpTextField(_ otpTextField: OTPTextField, createDigitLabelInSlot slot: Int) -> UILabel
}

@available(iOS 14.0, *)
public protocol OTPTextFieldDelegate: AnyObject {
    func otpTextField(_ otpTextField: OTPTextField, updated text: String)
    func otpTextField(_ otpTextField: OTPTextField, didChange text: String, at slot: Int)
}

@available(iOS 14.0, *)
open class OTPTextField: UITextField {
    // MARK: - Views
    private let labelsStackView = UIStackView()
    private var digitsLabels: [UILabel] = []
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    // MARK: - Properties
    open weak var dataSource: OTPTextFieldDataSource?
    open weak var OTPDelegate: OTPTextFieldDelegate?
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Public Methods
    public func reloadData() {
        createAndAddDigitLabelsToLabelsStackView()
    }
    
    // MARK: - Private Handlers
    private func configureUI() {
        setup()
        updateLabelsStackView()
        createAndAddDigitLabelsToLabelsStackView()
    }
    
    private func setup() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        borderStyle = .none
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
        addGestureRecognizer(tapRecognizer)
    }
    
    private func updateLabelsStackView() {
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .horizontal
        labelsStackView.alignment = .fill
        labelsStackView.distribution = .fillEqually
        labelsStackView.spacing = 8
        addSubview(labelsStackView)
        fillLabelsStackViewToOTPTextField()
    }
    
    private func createAndAddDigitLabelsToLabelsStackView() {
        guard let dataSource = dataSource else {
            return
        }
        clearLabelsStackView()

        let count = dataSource.numberOfSlots(in: self)
        for slot in 1 ... count {
            let label = dataSource.otpTextField(self, createDigitLabelInSlot: slot)
            label.translatesAutoresizingMaskIntoConstraints = false
            labelsStackView.addArrangedSubview(label)
            digitsLabels.append(label)
        }
    }
    
    private func clearLabelsStackView() {
        labelsStackView
            .arrangedSubviews
            .forEach { view in
            self.labelsStackView.removeArrangedSubview(view)
        }
        digitsLabels.removeAll()
    }
    
    private func fillLabelsStackViewToOTPTextField() {
        labelsStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
// MARK: - UITextFieldDelegate
@available(iOS 14.0, *)
extension OTPTextField: UITextFieldDelegate {
    // Handling character input in the text field.
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let charactersCount = textField.text?.count else { return false }
        return charactersCount < digitsLabels.count || string == ""
    }
    
    // Handling text changes in the text field.
    @objc private func textDidChange() {
        guard let text = text, text.count <= digitsLabels.count else {
            return
        }
        updateDigitLabels(for: text)
        OTPDelegate?.otpTextField(self, updated: text)
    }
}
// MARK: - Private Handlers
//
@available(iOS 14.0, *)
private extension OTPTextField {
    // Updating the digit labels based on the entered OTP code.
    func updateDigitLabels(for text: String) {
        for index in 0 ..< digitsLabels.count {
            updateDigitLabel(at: index, for: text)
        }
    }
    
    // Updating a single digit label based on the entered OTP code.
    func updateDigitLabel(at index: Int, for text: String) {
        let label = digitsLabels[index]
        
        if index < text.count {
            let characterIndex = text.index(text.startIndex, offsetBy: index)
            let character = String(text[characterIndex])
            label.text = character
            OTPDelegate?.otpTextField(self, didChange: character, at: index)
        } else {
            label.text = dataSource?.otpTextField(self, defaultCharacterInSlot: index)
        }
    }
}

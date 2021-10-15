//
//  ChangePasswordPage.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 11.05.21.
//

import UIKit
import SnapKit

class ChangePasswordPage: UIViewController, AlertPresentable, LoadingViewable, BannerNotificationPresentable{
    private var bottomConstraint: Constraint?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img-back-button"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Изменить пароль"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "img-subsettings-background"))
        image.clipsToBounds = true
        return image
    }()
    
    private var oldPasswordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.title = "Старый пароль"
        textField.placeholder = "Введите старый пароль"
        return textField
    }()
    
    private var newPasswordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.title = "Новый пароль"
        textField.placeholder = "Введите новый пароль"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private var repeatPasswordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.title = "Новый пароль повторно"
        textField.placeholder = "Введите новый пароль повторно"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Подтвердить", for: .normal)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
        
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                oldPasswordTextField,
                newPasswordTextField,
                repeatPasswordTextField
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Изменить пароль"
        view.backgroundColor =  .background
        registerForKeyboardEvents()
        layoutUI()
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapConfirmButton() {
        let service = AuthServiceImplementation()
        guard
            let oldPasssword = oldPasswordTextField.text,
            let newPassword = newPasswordTextField.text,
            let repeatPassword = repeatPasswordTextField.text,
            !oldPasssword.isEmpty,
            !newPassword.isEmpty,
            !repeatPassword.isEmpty,
            newPassword == repeatPassword
        else {
            showAlert(title: "Внимание", message: "Заполните поля корректно")
            return
        }
        showLoader()
        service.changePassword(
            oldPassword: oldPasssword,
            newPassword: newPassword,
            success: { [weak self] response in
                self?.hideLoader()
                if let changed = response.changed, !changed.isEmpty {
                    self?.showSuccessBanner("success".localized, "Ваш пароль успешно изменен! Вы можете выполнить вход с новым паролем.")
                    print("Password is changed: \(response)")
                } else {
                    self?.showErrorBanner(CommonCoreError.passwordVerification)
                }
            },
            failure: { [weak self] error in
                self?.hideLoader()
                self?.showErrorBanner(error)
            }
        )
    }
    
    private func layoutUI() {
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(backButton.snp.bottom).offset(16)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            bottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24).constraint
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        backButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}

extension ChangePasswordPage: KeyboardObserving {
    func keyboardWillShow(_ height: CGFloat) {
        let offset = height - view.safeAreaInsets.bottom + 20
        bottomConstraint?.update(offset: -offset)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        func keyboardWillHide() {
            bottomConstraint?.update(offset: -24)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
}

extension ChangePasswordPage: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
}


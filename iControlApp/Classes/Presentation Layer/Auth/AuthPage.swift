//
//  ViewController.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 19.04.21.
//

import UIKit
import SnapKit

class AuthPage: UIViewController, AlertPresentable, LoadingViewable, BannerNotificationPresentable {
    //MARK: Properties
    private var bottomConstraint: Constraint?
    private let authPageViewModel: AuthPageViewModel = AuthPageViewModel(authService: AuthServiceImplementation())
    
    //MARK: Views
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: Config.imgAuthPage)
        image.clipsToBounds = true
        return image
    }()
    
    private var phoneTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.title = "phone.number".localized
        textField.placeholder = "Введите свой номер"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.title = "Пароль"
        textField.placeholder = "Введите свой пароль"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordTagButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eye-show")?.withTintColor(.white), for: .normal)
        button.setImage(UIImage(named: "eye-hide")?.withTintColor(.white), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordDisplay), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [phoneTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    
    // MARK: Init
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        layoutUI()
        registerForKeyboardEvents()
        configureTextFields()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        phoneTextField.text = nil
        passwordTextField.text = nil
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Actions
    @objc private func didTapNextButton() {
        guard
            let phone = phoneTextField.text,
            let password = passwordTextField.text,
            !phone.isEmpty,
            !password.isEmpty
        else {
            showAlert(title: "Внимание", message: "Заполните поля корректно")
            return
        }
        
        authPageViewModel.login(phone, password)
    }
    
    @objc func togglePasswordDisplay(sender: UIButton) {
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
        passwordTextField.isSecureTextEntry = !isSelected
    }
    
    // MARK: Methods
    private func bindViewModel() {
        authPageViewModel.didStartRequest = { [weak self] in
            self?.showLoader()
        }
        
        authPageViewModel.didEndRequest = { [weak self] in
            self?.hideLoader()
        }
        
        authPageViewModel.didFailedRequest = { [weak self] error in
            self?.showErrorBanner(error)
        }
        
        authPageViewModel.didLogIn = { [weak self] in
            let vc = HomePage()
            self?.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    private func configureTextFields() {
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.rightView = passwordTagButton
        passwordTextField.rightViewMode = .always
    }
        
    // MARK: UI Layout
    private func layoutUI() {
        title = "Логин"
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(50)
            bottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160).constraint
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
    
    }

}

extension AuthPage: KeyboardObserving {
    func keyboardWillShow(_ height: CGFloat) {
        let offset = height - view.safeAreaInsets.bottom + 20
        bottomConstraint?.update(offset: -offset)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        func keyboardWillHide() {
            bottomConstraint?.update(offset: -160)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
}


extension AuthPage: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            phoneTextField.resignFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}

//
//  ViewController.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 19.04.21.
//

import UIKit
import SnapKit

class AuthPage: UIViewController, BannerNotificationPresentable, LoadingViewable {
    private var bottomConstraint: Constraint?
    
    private var loginTextInputView = TextInputView()
    private var passwordTextInputView = TextInputView()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next"), for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginTextInputView, passwordTextInputView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private let bottomRunningImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "running-man")?.withTintColor(.main ?? .green))
        return image
    }()
    
    private let topRunningImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "running-man")?.withTintColor(.main ?? .green))
        return image
    }()
    
    private let authPageViewModel: AuthPageViewModel = AuthPageViewModel(authService: AuthServiceImplementation())
    
//    init(authViewModel: AuthPageViewModel) {
//        self.authPageViewModel = authViewModel
//        super.init(nibName: nil, bundle: nil)
//
//    }
//
//    required init?(coder: NSCoder) {
//        //super.init(coder: coder)
//        //fatalError("init(coder:) has not been implemented")
//    }
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        layoutUI()
        configure()
        registerForKeyboardEvents()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
            let vc = QRScannerPage()
            self?.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc private func didTapNextButton() {
        if let login = loginTextInputView.textField.text, let password = passwordTextInputView.textField.text {
            authPageViewModel.login(login, password)
        }
        
    }
    private func layoutUI() {
        title = "Логин"
        view.backgroundColor =  .background
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(70)
            $0.height.equalTo(44)
            bottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160).constraint
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        view.addSubview(bottomRunningImage)
        bottomRunningImage.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.width.equalTo(160)
            $0.leading.equalToSuperview().inset(-50)
            $0.bottom.equalToSuperview().inset(-100)
        }
        
        view.addSubview(topRunningImage)
        topRunningImage.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.width.equalTo(230)
            $0.trailing.equalToSuperview().inset(-80)
            $0.top.equalToSuperview().inset(40)
        }
        
        
    }
    
    private func configure() {
        loginTextInputView.configure(
            title: "Логин",
            placeHolder: "Введите свой логин",
            state: .common
        )
        
        passwordTextInputView.configure(
            title: "Пароль",
            placeHolder: "Введите свой пароль",
            state: .password
        )
    }
    private func registerUser() {
//        authService.registerUser("пп") { status in
//            print(status)
//        } failure: { (error) in
//            debugPrint(error.errorDescription)
//        }

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

//
//  SettingsPage.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 6.05.21.
//

import UIKit
import SnapKit

class SettingsPage: UIViewController {
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img-back-button"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "img-settings-background"))
        image.clipsToBounds = true
        return image
    }()
    
    private let changePasswordButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Изменить пароль", for: .normal)
        button.addTarget(self, action: #selector(didTapChangePasswordButton), for: .touchUpInside)
        return button
    }()
    
    private let changeImageButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Изменить фотографию", for: .normal)
        button.addTarget(self, action: #selector(didTapChangeImageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changePasswordButton, changeImageButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        view.backgroundColor =  .background
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc private func didTapChangePasswordButton() {
        let viewController = ChangePasswordPage()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func didTapChangeImageButton() {
        let viewController = ChangeImagePage()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
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
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.maxY / 3 + UIScreen.main.bounds.width / 8 + UIScreen.main.bounds.width / 2)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        [changePasswordButton, changeImageButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
    }
}

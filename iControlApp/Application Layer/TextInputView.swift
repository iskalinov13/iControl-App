//
//  TextInputView.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 28.04.21.
//

import UIKit

enum TextFieldState {
    case common, password
}

class TextInputView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .white
        return textField
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, line])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.setCustomSpacing(20, after: titleLabel)
        stackView.setCustomSpacing(8, after: textField)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, placeHolder: String, state: TextFieldState) {
        titleLabel.text = title
        textField.placeholder = placeHolder
        textField.isSecureTextEntry = state == .password
        textField.setPlaceHolderColor()
    }
    private func layoutUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
    }
}

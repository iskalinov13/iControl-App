//
//  CustomButton.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 8.05.21.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.background, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        setImage( UIImage(named: "img-button-arrow"), for: .normal)
        backgroundColor = .main
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
        clipsToBounds = true
        addCornerRadius(10)
        addShadow(cornerRadius: 10, shadowColor: .black, shadowOffset:  CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.25, shadowRadius: 2)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let imageWidth = imageView?.frame.width ?? 0
        let titleWidth = titleLabel?.frame.width ?? 0
        let availableWidth = availableSpace.width - imageEdgeInsets.right - imageWidth - titleWidth
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2 + 8, bottom: 0, right: 16)
        }
}

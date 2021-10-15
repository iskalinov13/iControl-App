//
//  CustomTextField.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 7.05.21.
//

import UIKit

class CustomTextField: FloatingTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .white
        titleColor = .white
        lineColor = .white
        placeholderColor = .white
        placeholderFont = .systemFont(ofSize: 16)
        font = .systemFont(ofSize: 16)
        selectedTitleColor = .white
        selectedLineColor = .white
        titleFont = .systemFont(ofSize: 14, weight: .bold)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textHeight() -> CGFloat {
        guard let font = self.font else {
            return 0.0
        }

        return font.lineHeight + 20.0
    }
}

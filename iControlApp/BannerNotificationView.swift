//
//  BannerNotificationView.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import UIKit

final class BannerNotificationView: UIView {
    enum Style {
        case error
        case success
        case notification
    }

    private let style: Style

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGestureRecognizer)
        return panGestureRecognizer
    }()

    private var dismissTimer: Timer?
    private var windowFrame: CGRect {
        guard
            let frame = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.frame
        else { return .zero }
        return frame
    }

    private var size: CGSize {
        return CGSize(width: windowFrame.width - 32, height: 60)
    }

    private var initialY: CGFloat = 0

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        layoutUI()
        stylize()
        addGestureRecognizer(panGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        frame = CGRect(x: 16, y: -(size.height), width: size.width, height: size.height)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-52)
        }
        
        addSubview(button)
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }

    private func stylize() {
        backgroundColor = UIColor.BannerNotification.backgroundColor(for: style)
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.15

        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }

    func display(on: UIView) {
        on.addSubview(self)
        present()
    }

    private func present() {
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(dismiss),
            userInfo: nil,
            repeats: false
        )

        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y = 50
        }
    }

    @objc private func dismiss() {
        dismissTimer?.invalidate()
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.frame.origin.y = -self.frame.height
            }, completion: { _ in
                self.removeFromSuperview()
            }
        )
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let superview = superview else { return }

        switch sender.state {
        case .began:
            dismissTimer?.invalidate()
            initialY = frame.origin.y
        case .changed:
            break
        default:
            if sender.velocity(in: superview).y < 0 {
                dismiss()
            } else {
                present()
            }
        }
    }
}

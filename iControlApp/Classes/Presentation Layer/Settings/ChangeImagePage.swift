//
//  ChangeImagePage.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 11.05.21.
//

import UIKit
import iCarousel

class ChangeImagePage: UIViewController {
    
    let carousel: iCarousel = {
        let carousel = iCarousel()
        carousel.type = .rotary
        return carousel
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img-back-button"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Изменить фото"
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
    
    private let uploadButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Загрузить фотографию", for: .normal)
        button.setImage(UIImage(named: "img-gallery"), for: .normal)
        button.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
        return button
    }()
    
    private let cameraButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Сделать снимок", for: .normal)
        button.setImage(UIImage(named: "img-camera"), for: .normal)
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [uploadButton, cameraButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .background
        carousel.dataSource = self
        layoutUI()
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapUploadButton() {
        showImagePickerController(sourceType: .photoLibrary)
    }
    
    @objc private func didTapCameraButton() {
        showImagePickerController(sourceType: .camera)
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
                
        backButton.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        backButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        view.addSubview(carousel)
        carousel.snp.makeConstraints {
            $0.width.equalTo(view.bounds.width)
            $0.height.equalTo(400)
            $0.top.equalTo(backButton.snp.bottom).inset(100)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(carousel.snp.bottom).offset(48)
        }
        
        [uploadButton, cameraButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }
    }
}


extension ChangeImagePage: iCarouselDataSource {
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 1.4, height: self.view.frame.height / 3))
        view.backgroundColor = .main
        
        let imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        if let imageUrl = CurrentUser.userImages?[index], let url = URL(string: imageUrl) {
            imageView.load(url: url)
        } else {
            imageView.image = UIImage(named: "image1")
        }
        
        return view
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 3
    }
}


extension ChangeImagePage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        controller.sourceType = sourceType
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            print("Image: \(image)")
        }
        dismiss(animated: true, completion: nil)
    }
}

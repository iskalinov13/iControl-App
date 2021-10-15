//
//  QRScannerPage.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 28.04.21.
//

import UIKit
import AVFoundation
 
class HomePage: UIViewController, AlertPresentable, LoadingViewable, BannerNotificationPresentable {
    
    // MARK: Properties
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "img-logout"), for: .normal)
        button.addTarget(self, action: #selector(didLogOutButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
        
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "img-home-background"))
        image.clipsToBounds = true
        return image
    }()
    
    private let qrCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Просканируйте QR код"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let scannButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Просканировать повторно", for: .normal)
        button.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        return button
    }()
    
    private let settingsButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Изменить пароль", for: .normal)
        button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scannButton, settingsButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    // MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setUpCaptureVideoPlayer()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if avCaptureSession?.isRunning == false {
            avCaptureSession.startRunning()
        } else if avCaptureSession?.isRunning == true {
            avCaptureSession.stopRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Methods
    @objc private func didTapScanButton() {
        if avCaptureSession?.isRunning == false {
            avCaptureSession.startRunning()
        } else if avCaptureSession?.isRunning == true {
            avCaptureSession.stopRunning()
        }
        print("Scan tapped")
    }
    
    @objc private func didTapSettingsButton() {
        let viewController = ChangePasswordPage()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func didTapHistoryButton() {
    }
    
    @objc private func didTapUploadButton() {
        showImagePickerController(sourceType: .photoLibrary)
    }
    
    @objc private func didTapTakeImageButton() {
        showImagePickerController(sourceType: .camera)
    }
    
    @objc private func didLogOutButton() {
        CurrentUser.id = nil
        CurrentUser.access = nil
        CurrentUser.refresh = nil
        navigationController?.popViewController(animated: true)
    }
    // MARK: UI
    private func layoutUI() {
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
            
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(qrCodeLabel)
        qrCodeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.maxY / 3 + 20)
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.maxY / 3 + UIScreen.main.bounds.width / 8 + UIScreen.main.bounds.width / 2 + 50)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        [scannButton, settingsButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }
    }
    
}

// MARK: AVCaptureMetadata
extension HomePage : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let service = AuthServiceImplementation()
        guard let userId = CurrentUser.id else { return }
        showLoader()
        service.enter(
            userId: userId,
            qrCode: code,
            success: { [weak self] res in
                self?.hideLoader()
                if let isExit = res.isExit, isExit {
                    self?.showSuccessBanner(
                        "success".localized,
                        "Вы успешно вышли из системы. Спасибо за пользование TrueGym!"
                    )
                } else {
                    if let open = res.open, open {
                        self?.showSuccessBanner(
                            "success".localized,
                            "Вы успешно вошли в систему. Добро пожаловать, \(CurrentUser.name ?? "")! Мы рады, что вы здесь"
                        )
                    } else {
                        self?.showNotificationBanner("Информация", "Упсс! Камера не распознала ваше лицо. Просканируйте QR код еще раз")
                    }
                }
                
            }, failure: { [weak self] error in
                self?.hideLoader()
                self?.showErrorBanner(error)
            }
        )
        print(code)
    }
}

// MARK: CaptureVideoPlayer set up
extension HomePage {
    private func setUpCaptureVideoPlayer() {
        avCaptureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            self.failed()
            return
        }
        let avVideoInput: AVCaptureDeviceInput
        
        do {
            avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            self.failed()
            return
        }
        
        if (self.avCaptureSession.canAddInput(avVideoInput)) {
            self.avCaptureSession.addInput(avVideoInput)
        } else {
            self.failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.avCaptureSession.canAddOutput(metadataOutput)) {
            self.avCaptureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
        } else {
            self.failed()
            return
        }
        
        self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
        self.avPreviewLayer.frame = CGRect(
            x:  UIScreen.main.bounds.maxX / 2 - UIScreen.main.bounds.width / 4,
            y: UIScreen.main.bounds.maxY / 3 + UIScreen.main.bounds.width / 8 + 20,
            width: UIScreen.main.bounds.width / 2,
            height: UIScreen.main.bounds.width / 2
        )
        self.avPreviewLayer.videoGravity = .resizeAspectFill
        self.avPreviewLayer.borderWidth = 10
        self.avPreviewLayer.cornerRadius = 10
        self.avPreviewLayer.borderColor = UIColor.main?.cgColor
        self.backgroundImage.layer.addSublayer(self.avPreviewLayer)
    }
    
    func failed() {
        let alert = UIAlertController(
            title: "Scanner not supported",
            message: "Please use a device with a camera. Because this device does not support scanning a code",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        avCaptureSession = nil
    }
}


extension HomePage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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




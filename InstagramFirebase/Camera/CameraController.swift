//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/9/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController,
    AVCapturePhotoCaptureDelegate,
    UIViewControllerTransitioningDelegate {
    
    // MARK: - UI Element Definitions

    let capturePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        setupCaptureSession()
        setupHUD()
    }
    
    // MARK: - Hide Status Bar
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Present / Dismiss Custom Transition
    
    let customAnimationPresentor = CustomAnimationPresentor()
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }
    
    let customAnimationDismisser = CustomAnimationDismisser()
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    // MARK: - position UI Elements
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, leading: nil,
                                  bottom: view.bottomAnchor, trailing: nil,
                                  paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0,
                                  width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, leading: nil, bottom: nil,
                             trailing: view.trailingAnchor,
                             paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12,
                             width: 50, height: 50)
    }
    
    // MARK: - Capture Photo
    
    @objc fileprivate func handleCapturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        
        #if (!arch(x86_64))
            guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
            output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()

        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                             bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
    }
    
    let output = AVCapturePhotoOutput()

    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // 1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("could not setup camera input: ", err)
        }
        
        // 2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        // 3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

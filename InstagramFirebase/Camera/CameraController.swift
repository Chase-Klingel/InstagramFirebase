//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/9/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
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
    
    @objc fileprivate func handleCapturePhoto() {
        // TBD
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
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
    
    // MARK: - Capture Session I / O
    
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
        let output = AVCapturePhotoOutput()
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

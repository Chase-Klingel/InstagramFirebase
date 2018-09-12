//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by Chase Klingel on 9/11/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    // MARK: - Cancel From Preview
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleCancel() {
        self.removeFromSuperview()
    }
    
    // MARK: - Save Photo
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library ", err)
                
                return
            }
            
            print("Successfully saved image to library")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully!"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textColor = .white
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.textAlignment = .center
                savedLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 80)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.8,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                               animations: {
                    savedLabel.layer.transform =
                        CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.75,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: .curveEaseOut,
                                   animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                        savedLabel.alpha = 0
                    }, completion: { (_) in
                        savedLabel.removeFromSuperview()
                    })
                })
            }
            
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        anchorPreviewImage()
        anchorCancelButton()
        anchorSaveButton()
    }
    
    // MARK: - UI Element Positioning
    
    fileprivate func anchorPreviewImage() {
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                bottom: bottomAnchor, trailing: trailingAnchor,
                                paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                width: 0, height: 0)
    }
    
    fileprivate func anchorCancelButton() {
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, leading: leadingAnchor,
                            bottom: nil, trailing: nil, paddingTop: 12,
                            paddingLeft: 12, paddingBottom: 0, paddingRight: 0,
                            width: 50, height: 50)
    }
    
    fileprivate func anchorSaveButton() {
        addSubview(saveButton)
        saveButton.anchor(top: nil, leading: leadingAnchor,
                          bottom: bottomAnchor, trailing: nil,
                          paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0,
                          width: 50, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

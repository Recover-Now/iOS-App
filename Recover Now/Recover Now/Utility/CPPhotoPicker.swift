//
//  CPPhotoPicker.swift
//  True Pass
//
//  Created by Cliff Panos on 8/10/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import UIKit
import PhotosUI

class CPPhotoPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    ///The message to be displayed when the user has chosen to not give the application access to Photos
    public var goToSettingsMessage = "Access to Photos is not currently allowed for True Pass. You can change this in Settings"
    
    ///The PHPhotoLibrary authorization status for the application
    var authStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    unowned internal var viewController: UIViewController
    
    /**
     Use this variable to set what action will be triggered when the user selects a photo as a UIImage.
     # Capturing self:
     - Most often, it will be necessary to capture `self` in order to provide some information for the UIImagePickerController request. Example:
        - `self.imageView.image = image`
     - Make sure to capture `self` as unowned in an explicit capture list:
     - `[unowned self](image) in ...`
     */
    public var photoSelectedAction: ((UIImage?) -> Void)?
    
    /**
     Use this variable to set what action will be triggered when if the picker is dismissed.
     # Capturing self:
     - If you capture `self`, capture it as unowned in an explicit capture list:
     - `[unowned self] in ...`
     # Make sure to call self.dismiss(animated: true) at the end of this function
     */
    public var photoPickerDismissedAction: (() -> Void)?
    
    /**
     Use this variable to set to setup the UIImagePickerController popup presentation.
     # Capturing self:
     - If you capture `self`, capture it as unowned in an explicit capture list:
     - `[unowned self] in ...`
     */
    public var popoverPresentationSetup: ((UIPopoverPresentationController) -> Void)?
    
    public init(vc: UIViewController) {
        self.viewController = vc
    }
    
    
    
    //MARK: - Photo Picker functionality
    
    
    
    ///Present the Photo Picker if authorized and otherwise display alerts to tell the user how to authorize the application. NOTE: on iPad, the cropped image will NOT be returned because UIImagePicker currently has a bug on iPad that causes cropping to stretch the image incorrectly. So, the original image is instead returned on iPad.
    public func pickImageConsideringAuth() {
        if authStatus == .authorized {
            presentPhotoPicker()
        } else if authStatus == .notDetermined {
            viewController.showOptionsAlert("Access Photos?", message: "Would you like to allow True Pass to access your photos?", left: "No", right: "Yes", handlerOne: nil, handlerTwo: {
                
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.presentPhotoPicker()
                    }
                }
                
            })
        } else {
            viewController.showOptionsAlert("True Pass Not Authorized", message: goToSettingsMessage, left: "OK", right: "Settings", handlerOne: nil) {
                if let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(settingsAppURL)
                }
            }
        }
    }
    
    internal func presentPhotoPicker() {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.viewController.showSimpleAlert("Photos Library Unavailable", message: "Due to some external reason, True Pass was unable to access your Photo Library")
        }
        
        let photoPickerVC = UIImagePickerController()
        photoPickerVC.allowsEditing = true
        photoPickerVC.sourceType = .photoLibrary
        photoPickerVC.delegate = self
//        photoPickerVC.preferredContentSize = CGSize(width: 333, height: 700)
        
        DispatchQueue.main.async {
            photoPickerVC.modalPresentationStyle = .popover
            self.viewController.present(photoPickerVC, animated: true)
            if let popoverSetup = self.popoverPresentationSetup, let controller = photoPickerVC.popoverPresentationController {
                popoverSetup(controller)
            } else {
                print("Popover presentation controller setup incomplete for photo picker.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        photoPickerDismissedAction?()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image: UIImage?
        let preferredImage = UIDevice.current.userInterfaceIdiom == .pad ? UIImagePickerControllerOriginalImage : UIImagePickerControllerEditedImage
        if let selectedImage = info[preferredImage] as? UIImage? {
            image = selectedImage
        }
        //Ensure that the photo is not too large
        if let existingImage = image {
            image = existingImage.drawAspectFill(in: CGRect(x: 0, y: 0, width: 400, height: 400))
        }
        if let action = photoSelectedAction {
            action(image)
        } else {
            print("A photoSelectedAction has not yet been set for this CPPhotosManager")
        }
    }
    
    
    
}

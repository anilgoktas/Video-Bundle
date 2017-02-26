//
//  CameraUsableType.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/18/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit
import PermissionScope

protocol CameraUsableType: AlertPresentable { }

extension CameraUsableType where Self: UIViewController {
    
    func configureCameraPermission() {
        switch PermissionScope().statusCamera() {
        case .unknown: PermissionScope().requestCamera()
        case .unauthorized, .disabled: alertCameraPermission()
        case .authorized: break
        }
    }
    
    func askCameraPermission() {
        if PermissionScope().statusCamera() == .unknown {
            PermissionScope().requestCamera()
        } else if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func alertCameraPermission() {
        let alertController = UIAlertController(title: "Camera Error", message: "Please allow access to camera to use application features.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(openAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

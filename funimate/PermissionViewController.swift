//
//  PermissionViewController.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/18/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit
import PermissionScope

final class PermissionViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var grantPermissionButton: UIButton! {
        didSet { configurePermissionButton() }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - IBActions
    
    @IBAction func askCameraPermission(_ sender: AnyObject) {
        askCameraPermission()
    }
    
    @IBAction func showCamera(_ sender: AnyObject) {
        guard PermissionScope().statusCamera() == .authorized
        else { alertCameraPermission(); return }
        
        performSegue(withIdentifier: .camera)
    }
    
}

// MARK: - Configurable

extension PermissionViewController: Configurable {
    
    func configureModel() {
        configureCameraPermission()
    }
    
    func configureObservers() {
        PermissionScope().onAuthChange = { [weak self] (finished, results) in
            self?.configurePermissionButton()
        }
    }
    
}

// MARK: - SegueHandler

extension PermissionViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case camera
    }
    
}

// MARK: - CameraUsableType

extension PermissionViewController: CameraUsableType { }

// MARK: - Helper Functions

extension PermissionViewController {
    
    fileprivate func configurePermissionButton() {
        let status = PermissionScope().statusCamera()
        let shouldNotShow = (status == .authorized || status == .unknown)
        grantPermissionButton.isHidden = shouldNotShow
    }
    
}

//
//  AlertPresentable.swift
//  Tiyatro Takip
//
//  Created by Anıl Göktaş on 11/7/15.
//  Copyright © 2015 Anıl Göktaş. All rights reserved.
//

import Foundation
import UIKit

protocol AlertPresentable: class { }

extension AlertPresentable where Self: UIViewController {
    
    func alert(title: String, message: String, cancelButtonTitle: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { (_) in
            completion?()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, cancelTitle: String, destructiveTitle: String, destructive: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { (_) in
            destructive?()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, cancelTitle: String, defaultTitle: String, defaultCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        let defaultAction = UIAlertAction(title: defaultTitle, style: .default) { (_) in
            defaultCompletion?()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alertSomethingWentWrong() {
        alert(title: "Oops!", message: "Bir şeyler yanlış gitti, lütfen tekrar deneyin.", cancelButtonTitle: "Tamam")
    }
    
    func alertSomethingWentWrong(completion: @escaping () -> Void) {
        alert(title: "Oops!", message: "Bir şeyler yanlış gitti, lütfen tekrar deneyin.", cancelButtonTitle: "Tamam") { 
            completion()
        }
    }
    
    func alertViewWillPop(title: String, message: String, popTitle: String = "Geri", didPop: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let popAction = UIAlertAction(title: popTitle, style: .destructive) { (_) in
            didPop?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(popAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

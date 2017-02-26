//
//  UIView.swift
//  Tiyatro Takip
//
//  Created by Anıl Göktaş on 10/14/15.
//  Copyright © 2015 Anıl Göktaş. All rights reserved.
//

import UIKit

@IBDesignable
class View: UIView { }

// MARK: - IBInspectable

extension UIView {
    
    // MARK: Corner
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // MARK: Border
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    // MARK: Shadow
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let shadowColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: shadowColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
}

// MARK: - Snapshot Image

extension UIView {
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, UIScreen.main.scale)
        //UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage!
    }
    
}

//
//  ReusableViewCell.swift
//
//
//  Created by Anıl Göktaş on 4/28/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import UIKit

// MARK: - ReusableViewCell

protocol ReusableViewCell: ReusableView, NibLoadableView {
    static var estimatedHeight: CGFloat { get }
    
    func didEndDisplaying()
}

extension ReusableViewCell {
    static var estimatedHeight: CGFloat { return 44 }
    
    func didEndDisplaying() { }
}

// MARK: - ReusableView

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}

// MARK: - NibLoadableView

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

}

// MARK: - UICollectionView

extension UICollectionView {
    
    func register<ReusableViewCell: UICollectionViewCell>(_: ReusableViewCell.Type) where ReusableViewCell: ReusableView {
        register(ReusableViewCell.self, forCellWithReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func register<ReusableViewCell: UICollectionViewCell>(_: ReusableViewCell.Type) where ReusableViewCell: ReusableView, ReusableViewCell: NibLoadableView {
        let bundle = Bundle(for: ReusableViewCell.self)
        let nib = UINib(nibName: ReusableViewCell.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func dequeueReusableCell<ReusableViewCell: UICollectionViewCell>(forIndexPath indexPath: NSIndexPath) -> ReusableViewCell where ReusableViewCell: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: ReusableViewCell.reuseIdentifier, for: indexPath as IndexPath) as? ReusableViewCell
        else { fatalError("Could not dequeue cell with identifier: \(ReusableViewCell.reuseIdentifier)") }
        
        return cell
    }
    
}

// MARK: - UITableView

extension UITableView {
    
    func register<ReusableViewCell: UITableViewCell>(_: ReusableViewCell.Type) where ReusableViewCell: ReusableView {
        register(ReusableViewCell.self, forCellReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func register<ReusableViewCell: UITableViewCell>(_: ReusableViewCell.Type) where ReusableViewCell: ReusableView, ReusableViewCell: NibLoadableView {
        let bundle = Bundle(for: ReusableViewCell.self)
        let nib = UINib(nibName: ReusableViewCell.nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func dequeueReusableCell<ReusableViewCell: UITableViewCell>(forIndexPath indexPath: NSIndexPath) -> ReusableViewCell where ReusableViewCell: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: ReusableViewCell.reuseIdentifier, for: indexPath as IndexPath) as? ReusableViewCell
        else { fatalError("Could not dequeue cell with identifier: \(ReusableViewCell.reuseIdentifier)") }
        
        return cell
    }
    
}

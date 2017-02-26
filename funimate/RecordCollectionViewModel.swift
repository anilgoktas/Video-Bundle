//
//  RecordCollectionViewModel.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/24/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit

protocol RecordCollectionViewModelDelegate: class {
    func didSelectVideo(at index: Int)
    func shouldReloadCollectionView()
}

extension RecordCollectionViewModelDelegate {
    func didSelectVideo(at index: Int) { }
    func shouldReloadCollectionView() { }
}

final class RecordCollectionViewModel: NSObject {
    
    // MARK: - Properties
    
    fileprivate let videoBundle: VideoBundle
    weak var delegate: RecordCollectionViewModelDelegate?
    
    // MARK: - Life Cycle
    
    init(videoBundle: VideoBundle) {
        self.videoBundle = videoBundle
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Configurable

extension RecordCollectionViewModel: Configurable {
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: .videoDidConfigureThumbnailImage, name: .VideoDidConfigureThumbnailImage, object: nil)
    }
    
    @objc func videoDidConfigureThumbnailImage() {
        delegate?.shouldReloadCollectionView()
    }
    
}

// MARK: - UICollectionViewDataSource

extension RecordCollectionViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoBundle.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VideoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath as NSIndexPath)
        cell.configure(with: videoBundle.videos[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension RecordCollectionViewModel: UICollectionViewDelegate {
    
    fileprivate func cellSize(for collectionView: UICollectionView) -> CGSize {
        let cellHeight = collectionView.frame.size.height
        let cellWidth = cellHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectVideo(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReusableViewCell { cell.didEndDisplaying() }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecordCollectionViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(for: collectionView)
    }
    
}

// MARK: - Selector

private extension Selector {
    static let videoDidConfigureThumbnailImage = #selector(RecordCollectionViewModel.videoDidConfigureThumbnailImage)
}

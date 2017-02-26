//
//  PreviewCollectionViewModel.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/24/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit
import GPUImage

protocol PreviewCollectionViewModelDelegate: class {
    func shouldReloadCollectionView()
}

extension PreviewCollectionViewModelDelegate {
    func shouldReloadCollectionView() { }
}

final class PreviewCollectionViewModel: NSObject {
    
    // MARK: - Properties
    
    fileprivate let videoBundle: VideoBundle
    fileprivate let videoBundlePlayer: VideoBundlePlayer
    weak var delegate: PreviewCollectionViewModelDelegate?
    
    // MARK: - Life Cycle
    
    init(videoBundle: VideoBundle, videoView: GPUImageView) {
        self.videoBundle = videoBundle
        videoBundlePlayer = VideoBundlePlayer(bundle: videoBundle, view: videoView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Configurable

extension PreviewCollectionViewModel: Configurable {
    
    func configureModel() {
        videoBundlePlayer.delegate = self
    }
    
    func configureView() {
        videoBundlePlayer.play(at: 0)
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: .videoDidConfigureThumbnailImage, name: .VideoDidConfigureThumbnailImage, object: nil)
    }
    
    @objc func videoDidConfigureThumbnailImage() {
        delegate?.shouldReloadCollectionView()
    }
    
}

// MARK: - UICollectionViewDataSource

extension PreviewCollectionViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoBundle.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VideoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath as NSIndexPath)
        let isPlaying = (videoBundlePlayer.currentIndex == indexPath.row)
        cell.configure(with: videoBundle.videos[indexPath.row], isPlaying: isPlaying)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension PreviewCollectionViewModel: UICollectionViewDelegate {
    
    fileprivate func cellSize(for collectionView: UICollectionView) -> CGSize {
        let cellHeight = collectionView.frame.size.height
        let cellWidth = cellHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        videoBundlePlayer.play(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReusableViewCell { cell.didEndDisplaying() }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PreviewCollectionViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(for: collectionView)
    }
    
}

// MARK: - VideoBundlePlayerDelegate

extension PreviewCollectionViewModel: VideoBundlePlayerDelegate {
    
    func didStartPlaying(video: Video) {
        delegate?.shouldReloadCollectionView()
    }
    
    func videoIndexDidChange() {
        delegate?.shouldReloadCollectionView()
    }
    
}

// MARK: - Selector

private extension Selector {
    static let videoDidConfigureThumbnailImage = #selector(RecordCollectionViewModel.videoDidConfigureThumbnailImage)
}

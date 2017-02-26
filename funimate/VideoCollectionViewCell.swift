//
//  VideoCollectionViewCell.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/24/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit

final class VideoCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    // MARK: - Life Cycle
    
    func didEndDisplaying() {
        imageView.borderColor = .clear
    }

}

// MARK: - ReusableViewCell

extension VideoCollectionViewCell: ReusableViewCell { }

// MARK: - Configurable

extension VideoCollectionViewCell {
    
    func configure(with video: Video, isPlaying: Bool = false) {
        imageView.image = video.thumbnailImage
        imageView.borderColor = isPlaying ? .green : .clear
    }
    
}

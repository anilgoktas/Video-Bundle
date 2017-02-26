//
//  VideoBundle.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/23/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation
import GPUImage

final class VideoBundle {
    
    // MARK: - Properties
    
    fileprivate(set) var videos = [Video]()
    var duration: Double {
        return videos.map { $0.duration.seconds }.reduce(0.0) { $0 + $1 }
    }
    
    // MARK: - Life Cycle
    
    init() { }
    
}

// MARK: - Configurable

extension VideoBundle {
    
    func insert(video: Video) {
        videos.append(video)
        video.configureThumbnailImage()
    }
    
    func remove(at index: Int) {
        videos.remove(at: index)
    }
    
}

// MARK: - Constants

extension VideoBundle {
    
    struct Constants {
        static let maximumDuration = 5.0
    }
    
}

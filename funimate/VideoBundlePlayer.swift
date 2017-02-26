//
//  VideoBundlePlayer.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/24/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation
import GPUImage

protocol VideoBundlePlayerDelegate: class {
    func didStartPlaying(video: Video)
    func videoIndexDidChange()
}

extension VideoBundlePlayerDelegate {
    func didStartPlaying(video: Video) { }
    func videoIndexDidChange() { }
}

final class VideoBundlePlayer: NSObject {
    
    // MARK: - Properties
    
    let bundle: VideoBundle
    let view: GPUImageView
    fileprivate let shouldRepeat: Bool
    fileprivate(set) var currentIndex = 0 {
        didSet { delegate?.videoIndexDidChange() }
    }
    fileprivate var currentMovie: GPUImageMovie?
    weak var delegate: VideoBundlePlayerDelegate?
    
    // MARK: - Life Cycle
    
    init(bundle: VideoBundle, view: GPUImageView, shouldRepeat: Bool = true) {
        self.bundle = bundle
        self.view = view
        self.shouldRepeat = shouldRepeat
    }
    
}

// MARK: - Configurable

extension VideoBundlePlayer {
    
    fileprivate var currentVideo: Video? {
        guard let video = bundle.videos[safeIndex: currentIndex] else { return nil }
        return video
    }
    
    fileprivate func play(video: Video?) {
        guard let video = video else { return }
        do {
            currentMovie = try video.movie(shouldRepeat: false)
            currentMovie?.addTarget(view)
            currentMovie?.startProcessing()
            currentMovie?.delegate = self
            delegate?.didStartPlaying(video: video)
        } catch {
            print("Could not play video with id: \(video.videoID) \(error)")
        }
    }
    
    func play(at index: Int) {
        // Prevent cancelProcessing() method from calling didCompletePlayingMovie()
        currentMovie?.delegate = nil
        currentMovie?.cancelProcessing()
        currentMovie?.removeTarget(view)
        
        // Continue playing with the given index
        currentIndex = index
        play(video: currentVideo)
    }
    
    func playNextVideo() {
        if currentIndex < bundle.videos.count {
            currentIndex += 1
        }
        
        if (currentIndex >= bundle.videos.count) && shouldRepeat {
            currentIndex = 0
        }
        
        play(video: currentVideo)
    }
    
}

// MARK: - GPUImageMovieDelegate

extension VideoBundlePlayer: GPUImageMovieDelegate {
    
    func didCompletePlayingMovie() {
        currentMovie?.removeTarget(view)
        currentMovie = nil
        
        // Continue on main thread
        DispatchQueue.main.async { [weak self] in
            self?.playNextVideo()
        }
    }
    
}

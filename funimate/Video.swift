//
//  Video.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/19/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation
import GPUImage
import AVKit
import Async

enum GPUImageError: Error {
    case videoCamera
    case movie
    case movieWriter
}

final class Video {
    
    // MARK: - Properties
    
    fileprivate(set) var videoID: String
    var duration: CMTime!
    var thumbnailImage: UIImage?
    // TODO: - this may be moved to documents directory whether we want to keep it
    // fileprivate(set) var isSaved = false
    var fileURL: URL {
        // if isSaved -> return documentsDirectory
        return FileManager.default.temporaryDirectory.appendingPathComponent(videoID + ".mp4")
    }
    
    // MARK: - Life Cycle
    
    init(videoID: String = Date().iso8601) {
        self.videoID = videoID
    }
    
}

// MARK: - GPUImage

extension Video {
    
    // TODO: - This property may change for each device, check: https://github.com/dennisweissmann/DeviceKit
    var size: CGSize {
        return CGSize(width: 640, height: 480)
    }

    func movie(shouldRepeat: Bool = true) throws -> GPUImageMovie {
        guard let movie = GPUImageMovie(url: fileURL)
        else { throw GPUImageError.movie }
        
        movie.playAtActualSpeed = true
        movie.shouldRepeat = shouldRepeat
        return movie
    }
    
}

// MARK: - Configurable

extension Video {
    
    func configureThumbnailImage() {
        Async.background { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.thumbnailImage = try? weakSelf.generateThumbnailImage()
            
            Async.main {
                NotificationCenter.default.post(name: .VideoDidConfigureThumbnailImage, object: nil)
            }
        }
    }
    
    func configureForRecording() {
        removeFile()
    }
    
    fileprivate func removeFile() {
        guard FileManager.default.fileExists(atPath: fileURL.path)
        else { return }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Movie could not prepare for recording: \(error)")
        }
    }
    
}

// MARK: - Helper Functions

fileprivate extension Video {
    
    func generateThumbnailImage() throws -> UIImage {
        return try autoreleasepool {
            let asset = AVAsset(url: fileURL)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            let time = CMTime(seconds: 1, preferredTimescale: 1)
            let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        }
    }
    
}

// MARK: - Notification.Name

extension Notification.Name {
    static let VideoDidConfigureThumbnailImage = Notification.Name(rawValue: "VideoDidConfigureThumbnailImage")
}

//
//  VideoRecorder.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/23/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation
import GPUImage
import SwiftyTimer

// MARK: - VideoRecorderError

enum VideoRecorderError: Error {
    case reachedMaximumDuration
}

// MARK: - VideoRecorderDelegate

protocol VideoRecorderDelegate: class {
    func willStartRecording()
    func didStartRecording()
    func didFinishRecording()
    func recordStateDidChange(state: VideoRecorderState)
    func startRecordingDidFail(with error: Error)
    func recordProgressDidUpdate()
    func willForceRecordingToFinish()
}

extension VideoRecorderDelegate {
    func willStartRecording() { }
    func didStartRecording() { }
    func didFinishRecording() { }
    func recordStateDidChange(state: VideoRecorderState) { }
    func startRecordingDidFail(with error: Error) { }
    func recordProgressDidUpdate() { }
    func willForceRecordingToFinish() { }
}

// MARK: - VideoRecorder

final class VideoRecorder {
    
    // MARK: Properties
    
    let camera: GPUImageVideoCamera
    let maximumDuration: Double
    fileprivate var video: Video!
    fileprivate var writer: GPUImageMovieWriter!
    let bundle = VideoBundle()
    fileprivate(set) var state = VideoRecorderState.notRecording {
        didSet { delegate?.recordStateDidChange(state: state) }
    }
    weak var delegate: VideoRecorderDelegate?
    
    // MARK: Life Cycle
    
    init(with videoView: GPUImageView, maximumDuration: Double = VideoBundle.Constants.maximumDuration) throws {
        camera = try VideoRecorder.videoCamera(with: videoView)
        self.maximumDuration = maximumDuration
    }
    
    deinit {
        camera.removeTarget(writer)
    }
    
}

// MARK: - Configurable

extension VideoRecorder {
    
    fileprivate func configureForNewRecord() throws {
        guard canRecord else { throw VideoRecorderError.reachedMaximumDuration }
        
        camera.removeTarget(writer)
        
        video = Video()
        video.configureForRecording()
        
        writer = try VideoRecorder.movieWriter(video: video)
        video.duration = writer.duration
        camera.addTarget(writer)
    }
    
}

// MARK: - Recording

extension VideoRecorder {
    
    var recordProgress: Float {
        switch state {
        case .isRecording: return Float((writer.duration.seconds + bundle.duration) / maximumDuration)
        case .notRecording: return Float(bundle.duration / maximumDuration)
        }
    }
    
    var canRecord: Bool { return recordProgress < 1.0 }
    
    func changeState() {
        switch state {
        case .isRecording:
            finishRecording()
        case .notRecording:
            do {
                try startRecording()
                state = .isRecording
                configureTimer()
            } catch {
                print("Could not start video recording: \(error)")
                // Refresh state in order to call delegate method
                state = .notRecording
                delegate?.startRecordingDidFail(with: error)
            }
        }
    }
    
    private func configureTimer() {
        Timer.every(0.1.seconds) { [weak self] (timer: Timer) in
            guard let weakSelf = self, weakSelf.state == .isRecording
            else { timer.invalidate(); return }
            
            weakSelf.delegate?.recordProgressDidUpdate()
            
            if !weakSelf.canRecord {
                timer.invalidate()
                weakSelf.delegate?.willForceRecordingToFinish()
                weakSelf.finishRecording()
            }
        }
    }
    
    private func startRecording() throws {
        try configureForNewRecord()
        
        delegate?.willStartRecording()
        writer.startRecording()
        delegate?.didStartRecording()
    }
    
    private func finishRecording() {
        guard state == .isRecording else { return }
        
        writer.finishRecording { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.video.duration = weakSelf.writer.duration
            weakSelf.bundle.insert(video: weakSelf.video)
            
            // Call delegate methods on main thread.
            DispatchQueue.main.async { [weak self] in
                self?.state = .notRecording
                self?.delegate?.didFinishRecording()
            }
        }
    }
    
}

// MARK: - Property Initializers

extension VideoRecorder {
    
    fileprivate class func videoCamera(with videoView: GPUImageView) throws -> GPUImageVideoCamera {
        let preset = AVCaptureSessionPreset640x480
        guard let camera = GPUImageVideoCamera(sessionPreset: preset, cameraPosition: .back)
        else { throw GPUImageError.videoCamera }
        
        camera.outputImageOrientation = .portrait
        camera.addTarget(videoView)
        camera.startCapture()
        return camera
    }
    
    fileprivate class func movieWriter(video: Video) throws -> GPUImageMovieWriter {
        guard let movieWriter = GPUImageMovieWriter(movieURL: video.fileURL, size: video.size)
        else { throw GPUImageError.movieWriter }
        
        return movieWriter
    }
    
}

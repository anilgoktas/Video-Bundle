//
//  RecordViewController.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/18/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit
import GPUImage

final class RecordViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var videoView: GPUImageView!
    @IBOutlet fileprivate weak var progressView: UIProgressView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var stateButton: UIButton!
    @IBOutlet fileprivate weak var previewButton: UIButton!
    
    // MARK: - Properties
    
    fileprivate var videoRecorder: VideoRecorder!
    fileprivate var collectionViewModel: RecordCollectionViewModel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        videoRecorder.camera.resumeCameraCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        videoRecorder.camera.pauseCapture()
    }
    
    // MARK: - IBActions
    
    @IBAction func changeState(_ sender: AnyObject) {
        stateButton.isEnabled = false
        videoRecorder.changeState()
    }
    
    @IBAction func showPreview(_ sender: AnyObject) {
        guard videoRecorder.state == .notRecording else { return }
        performSegue(withIdentifier: .preview)
    }
    
}

// MARK: - Configurable

extension RecordViewController: Configurable {
    
    func configureView() {
        configureVideoRecorder()
        configureWithInitialState()
    }
    
    func configureCollectionView() {
        collectionViewModel = RecordCollectionViewModel(videoBundle: videoRecorder.bundle)
        collectionViewModel.delegate = self
        collectionView.register(VideoCollectionViewCell.self)
        collectionView.delegate = collectionViewModel
        collectionView.dataSource = collectionViewModel
        collectionViewModel.configure()
    }
    
    func configureVideoRecorder() {
        do {
            videoRecorder = try VideoRecorder(with: videoView)
            videoRecorder.delegate = self
        } catch {
            // TODO: - User interacted error
            print("Could not configure movie output: \(error)")
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

// MARK: - SegueHandler

extension RecordViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case preview
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
        let previewViewController = segue.destination as? PreviewViewController,
        segueIdentifier(for: segue) == .preview {
            previewViewController.videoBundle = videoRecorder.bundle
        }
    }
    
}

// MARK: - VideoRecorderDelegate

extension RecordViewController: VideoRecorderDelegate {
    
    fileprivate func configureWithInitialState() {
        progressView.setProgress(0.0, animated: false)
        stateButton.setTitle(VideoRecorderState.notRecording.title, for: .normal)
        previewButton.isHidden = true
    }
    
    func recordStateDidChange(state: VideoRecorderState) {
        stateButton.setTitle(state.title, for: .normal)
        stateButton.isEnabled = true
        previewButton.isHidden = (state == .isRecording)
    }
    
    func recordProgressDidUpdate() {
        progressView.setProgress(videoRecorder.recordProgress, animated: true)
    }
    
    func didFinishRecording() {
        // Show new videos
        collectionView.reloadData()
    }
    
    func startRecordingDidFail(with error: Error) {
        if let recorderError = error as? VideoRecorderError, recorderError == .reachedMaximumDuration {
            alertMaximumDuration()
        }
    }
    
}

// MARK: - RecordCollectionViewModelDelegate

extension RecordViewController: RecordCollectionViewModelDelegate {
    
    func shouldReloadCollectionView() {
        collectionView.reloadData()
    }
    
    func didSelectVideo(at index: Int) {
        alertVideoWillBeDeleted(at: index)
    }
    
}

// MARK: - AlertPresentable

extension RecordViewController: AlertPresentable {
    
    fileprivate func alertMaximumDuration() {
        let maximumDuration = Int(videoRecorder.maximumDuration)
        alert(title: "Oops!", message: "You have reached \(maximumDuration) seconds. Please delete a video to record new one.\n\nYou can delete a video by selecting them.", cancelButtonTitle: "OK")
    }
    
    fileprivate func alertVideoWillBeDeleted(at index: Int) {
        alert(title: "Delete Video", message: "Do you want to delete this video?", cancelTitle: "Cancel", destructiveTitle: "Delete") { [weak self] in
            self?.videoRecorder.bundle.remove(at: index)
            self?.recordProgressDidUpdate()
            self?.collectionView.reloadData()
        }
    }
    
}

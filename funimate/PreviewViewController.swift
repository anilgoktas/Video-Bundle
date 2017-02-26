//
//  PreviewViewController.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/20/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import UIKit
import GPUImage

final class PreviewViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var videoView: GPUImageView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var videoBundle: VideoBundle!
    var collectionViewModel: PreviewCollectionViewModel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Configurable

extension PreviewViewController: Configurable {
    
    func configureCollectionView() {
        collectionViewModel = PreviewCollectionViewModel(videoBundle: videoBundle, videoView: videoView)
        collectionViewModel.delegate = self
        collectionView.register(VideoCollectionViewCell.self)
        collectionView.delegate = collectionViewModel
        collectionView.dataSource = collectionViewModel
        collectionViewModel.configure()
    }
    
}

extension PreviewViewController: PreviewCollectionViewModelDelegate {
    
    func shouldReloadCollectionView() {
        collectionView.reloadData()
    }
    
}

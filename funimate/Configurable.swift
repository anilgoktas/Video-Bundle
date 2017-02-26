//
//  Configurable.swift
//  Tiyatro Takip
//
//  Created by Anıl Göktaş on 10/28/15.
//  Copyright © 2015 Anıl Göktaş. All rights reserved.
//

import Foundation

// MARK: - Configurable

protocol Configurable {
    
    func configure()
    func configureView()
    func configureModel()
    func configureObservers()
    func configureTableView()
    func configureTableViewBackground()
    func configureCollectionView()
    func configureCollectionViewBackground()
    func configurePeekPop()
    
}

// MARK: - Default

extension Configurable {
    
    func configure() {
        configureModel()
        configureView()
        configureObservers()
        configureTableView()
        configureCollectionView()
        configurePeekPop()
    }
    
    func configureView() { }
    
    func configureModel() { }
    
    func configureObservers() { }
    
    func configureTableView() {
        configureTableViewBackground()
    }
    
    func configureTableViewBackground() { }
    
    func configureCollectionView() {
        configureCollectionViewBackground()
    }
    
    func configureCollectionViewBackground() { }
    
    func configurePeekPop() { }
    
}
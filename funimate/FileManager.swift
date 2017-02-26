//
//  FileManager.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/19/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation

extension FileManager {
    
    var documentsDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[safeIndex: 0]
    }
    
}

//
//  Indexable.swift
//  Dizi Takip 2
//
//  Created by Anıl Göktaş on 1/6/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

extension Array {
    
    public subscript(safeIndex index: Index) -> _Element? {
        return (index >= 0 && index < count) ? self[index] : nil
    }
    
}

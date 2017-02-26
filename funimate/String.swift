//
//  String.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/19/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation

extension String {
    
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
    
}

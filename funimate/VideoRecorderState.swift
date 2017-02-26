//
//  VideoRecorderState.swift
//  funimate
//
//  Created by Anıl Göktaş on 2/21/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation

enum VideoRecorderState {
    case notRecording
    case isRecording
    
    var title: String {
        switch self {
        case .notRecording: return "Record"
        case .isRecording: return "Stop"
        }
    }
    
    var nextState: VideoRecorderState {
        switch self {
        case .notRecording: return .isRecording
        case .isRecording: return .notRecording
        }
    }
    
}

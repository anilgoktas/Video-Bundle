//
//  CGPoint.swift
//  tbf
//
//  Created by Anıl Göktaş on 6/12/16.
//  Copyright © 2016 Retter Mobile. All rights reserved.
//

import Foundation
import UIKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

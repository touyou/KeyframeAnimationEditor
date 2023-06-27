//
//  AnimationValue.swift
//
//
//  Created by 藤井陽介 on 2023/06/27.
//

import Foundation

public struct AnimationValue {
    public var scale = CGSize(width: 1.0, height: 1.0)
    
    public init(scale: CGSize = CGSize(width: 1.0, height: 1.0)) {
        self.scale = scale
    }
}

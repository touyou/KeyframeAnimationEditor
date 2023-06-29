//
//  File.swift
//  
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI

public struct KeyframeObject<Value> where Value: Animatable {
    let type = "spring"
    let to: Value
    let duration: Double?
    
    // Spring, Linear, Move, Cubic
    @KeyframeTrackContentBuilder<Value>
    var keyframe: some KeyframeTrackContent<Value> {
        if type == "spring" {
            SpringKeyframe(to, duration: duration)
        } else {
            CubicKeyframe(to, duration: duration ?? 0.5)
        }
    }
        
    public init(to: Value, duration: Double? = nil) {
        self.to = to
        self.duration = duration
    }
}

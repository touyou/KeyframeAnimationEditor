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
    
    public func getKeyframe() -> any KeyframeTrackContent {
        if type == "spring" {
            SpringKeyframe(to, duration: duration)
        } else {
            CubicKeyframe(to, duration: duration ?? 0.5)
        }
    }
    
    public init(to: Value, duration: Double?) {
        self.to = to
        self.duration = duration
    }
}

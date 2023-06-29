//
//  File.swift
//  
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI

public struct KeyframeObject<Value>: Identifiable where Value: Animatable {
    public let id: UUID
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
        self.id = UUID()
        self.to = to
        self.duration = duration
    }
}

extension KeyframeObject: CustomStringConvertible {
    public var description: String {
        "type: \(type), to: \(to), duration: \(String(describing: duration))"
    }
}

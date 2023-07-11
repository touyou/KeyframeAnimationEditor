//
//  File.swift
//  
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI

public struct KeyframeObject<Value>: Identifiable where Value: Animatable {
    public let id: UUID
    public let type: KeyframeType<Value>
    
    // Spring, Linear, Move, Cubic
    @KeyframeTrackContentBuilder<Value>
    public var keyframe: some KeyframeTrackContent<Value> {
        switch type {
        case let .cubic(to, duration, startVelocity, endVelocity):
            CubicKeyframe(to, duration: duration, startVelocity: startVelocity, endVelocity: endVelocity)
        case let .linear(to, duration, timingCurve):
            LinearKeyframe(to, duration: duration, timingCurve: timingCurve ?? .linear)
        case let .move(to):
            MoveKeyframe(to)
        case let .spring(to, duration, spring, startVelocity):
            SpringKeyframe(to, duration: duration, spring: spring ?? Spring(), startVelocity: startVelocity)
        }
    }
        
    public init(type: KeyframeType<Value>) {
        self.id = UUID()
        self.type = type
    }
}

extension KeyframeObject: CustomStringConvertible {
    public var description: String {
        type.description
    }
}

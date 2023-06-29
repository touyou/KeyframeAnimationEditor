//
//  File.swift
//  
//
//  Created by 藤井陽介 on 2023/06/29.
//

import SwiftUI

public enum KeyframeType<Value> where Value: Animatable {
    // to, duration, startVelocity, endVelocity
    case cubic(Value, Double, Value?, Value?)
    // to, duration, timingCurve
    case linear(Value, Double, UnitCurve?)
    // to
    case move(Value)
    // to, duration, spring, startVelocity
    case spring(Value, Double?, Spring?, Value?)
}

extension KeyframeType: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .cubic(to, duration, _, _):
            return "cubic to: \(to) duration: \(duration)"
        case let .linear(to, duration, _):
            return "linear to: \(to) duration: \(duration)"
        case let .move(to):
            return "move to: \(to)"
        case let .spring(to, duration, _, _):
            return "spring to: \(to) duration: \(String(describing: duration))"
        }
    }
}

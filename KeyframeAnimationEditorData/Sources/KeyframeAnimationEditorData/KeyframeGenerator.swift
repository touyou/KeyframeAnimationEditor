//
//  KeyframeGenerator.swift
//
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI

public struct KeyframeGenerator<Root, Value> where Value: Animatable {
    public let path: WritableKeyPath<Root, Value>
    
    public var keyframeObjects: [KeyframeObject<Value>]
    public var keyframeTrack: KeyframeTrack<Root, Value, some KeyframeTrackContent<Value>> {
        KeyframeTrack(path) {
            KeyframesBuilder.buildArray(keyframeObjects.map { $0.keyframe })
        }
    }

    public init(path: WritableKeyPath<Root, Value>, keyframeObjects: Array<KeyframeObject<Value>>) {
        self.path = path
        self.keyframeObjects = keyframeObjects
    }
}

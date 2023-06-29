//
//  KeyframeGenerator.swift
//
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI

public class KeyframeGenerator {
    public static func keyframeTrack<Root, Value>(path: WritableKeyPath<Root, Value>, keyframeObjects: [KeyframeObject<Value>]) -> KeyframeTrack<Root, Value, some KeyframeTrackContent<Value>> where Value: Animatable {
        KeyframeTrack(path) {
            KeyframesBuilder.buildArray(keyframeObjects.map { $0.keyframe })
        }
    }
}

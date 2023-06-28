//
//  KeyframeGenerator.swift
//
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI

public struct KeyframeGenerator<Root, Value, Content> where Value: Animatable, Content: KeyframeTrackContent, Value == Content.Value {
    public let path: WritableKeyPath<Root, Value>
    
    public var keyframeObjects: Array<KeyframeObject<Value>>
    public var keyframeTrack: KeyframeTrack<Root, Value, Content> {
        KeyframeTrack(path) {
            KeyframeTrackContentBuilder<Value>.buildArray(keyframes)
        }
    }
    
    var keyframes: [Content] {
        keyframeObjects.map { $0.getKeyframe() as! Content }
    }
    
    public init(path: WritableKeyPath<Root, Value>, keyframeObjects: Array<KeyframeObject<Value>>) {
        self.path = path
        self.keyframeObjects = keyframeObjects
    }
}

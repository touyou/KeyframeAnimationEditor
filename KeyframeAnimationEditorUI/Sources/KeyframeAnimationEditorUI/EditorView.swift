//
//  EditorView.swift
//  KeyframeAnimationEditor
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI
import KeyframeAnimationEditorData

public struct EditorView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            KeyframeAnimator(
                initialValue: AnimationValue(),
                repeating: true
            ) { values in
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .scaleEffect(values.scale)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    SpringKeyframe(CGSize(width: 2.0, height: 2.0), spring: .bouncy(duration: 1.0))
                }
            }
        }
        .padding()
    }
}

struct EditorView_Preview: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}

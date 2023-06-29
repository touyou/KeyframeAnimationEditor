//
//  EditorView.swift
//  KeyframeAnimationEditor
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI
import KeyframeAnimationEditorData

public struct EditorView: View {
    @State var keyframeObjects = [
        KeyframeObject(to: CGSize(width: 2.0, height: 2.0))
    ]
    @State var reviewId = 0
    
    public init() {}
    
    public var body: some View {
        HStack {
            VStack(alignment: .center) {
                Button("current animation: \(keyframeObjects.count)") {
                    keyframeObjects.append(KeyframeObject(to: CGSize(width: Double.random(in: 0.5..<3.0), height: Double.random(in: 0.5..<3.0))))
                    reviewId = reviewId + 1
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))

            VStack(alignment: .center) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .keyframeAnimator(
                        initialValue: AnimationValue(),
                        repeating: true
                    ) { content, value in
                        content
                            .scaleEffect(value.scale)
                    } keyframes: { _ in
                        KeyframeGenerator.keyframeTrack(path: \AnimationValue.scale, keyframeObjects: keyframeObjects)
                    }
                    .id("animation\(reviewId)")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
        .ignoresSafeArea(.all)
    }
}

struct EditorView_Preview: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}

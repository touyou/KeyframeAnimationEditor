//
//  EditorView.swift
//  KeyframeAnimationEditor
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI
import KeyframeAnimationEditorData

public struct EditorView: View {
    @State var keyframeObjects: [KeyframeObject<CGSize>] = []
    @State var reviewId = 0
    
    public init() {}
    
    public var body: some View {
        HStack {
            List {
                Section("control") {
                    Button("add spring animation") {
                        keyframeObjects.append(
                            KeyframeObject(
                                type: .spring(
                                    CGSize(width: Double.random(in: 0.5..<3.0), height: Double.random(in: 0.5..<3.0)),
                                    nil,
                                    nil,
                                    nil
                                )
                            )
                        )
                        reviewId = reviewId + 1
                    }
                    Button("add cubic animation") {
                        keyframeObjects.append(
                            KeyframeObject(
                                type: .cubic(
                                    CGSize(width: Double.random(in: 0.5..<3.0), height: Double.random(in: 0.5..<3.0)),
                                    0.5,
                                    nil,
                                    nil
                                )
                            )
                        )
                        reviewId = reviewId + 1
                    }
                    Button("add linear animation") {
                        keyframeObjects.append(
                            KeyframeObject(
                                type: .linear(
                                    CGSize(width: Double.random(in: 0.5..<3.0), height: Double.random(in: 0.5..<3.0)),
                                    0.5,
                                    nil
                                )
                            )
                        )
                        reviewId = reviewId + 1
                    }
                    Button("add move animation") {
                        keyframeObjects.append(
                            KeyframeObject(
                                type: .move(
                                    CGSize(width: Double.random(in: 0.5..<3.0), height: Double.random(in: 0.5..<3.0))
                                )
                            )
                        )
                        reviewId = reviewId + 1
                    }
                }
                
                Section("spring anim") {
                    ForEach(keyframeObjects) { object in
                        Text(object.description)
                    }
                    if keyframeObjects.isEmpty {
                        ContentUnavailableView("まだアニメーションがありません", systemImage: "cat.circle.fill")
                    }

                }
            }
            .listStyle(.insetGrouped)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

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

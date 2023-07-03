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

    @State var toX: CGFloat = 1.0
    @State var toY: CGFloat = 1.0
    @State var duration: Double = 2.0
    
    enum ModeType: String {
        case spring
        case cubic
        case linear
        case move
    }
    
    public init() {}
    
    public var body: some View {
        HStack {
            List {
                Section("control") {
                    HStack {
                        Text("目標のX座標: \(toX)")
                        Spacer()
                        Slider(value: $toX, in: 0.1...5.0)
                    }
                    HStack {
                        Text("目標のY座標: \(toY)")
                        Spacer()
                        Slider(value: $toY, in: 0.1...5.0)
                    }
                    HStack {
                        Text("継続時間: \(duration)")
                        Spacer()
                        Slider(value: $duration, in: 0.1...5.0)
                    }
                    Button("add spring animation") {
                        keyframeObjects.append(
                            KeyframeObject(type: .spring(CGSize(width: toX, height: toY), duration, nil, nil))
                        )
                        reviewId = reviewId + 1
                    }
                    Button("add cubic animation") {
                        keyframeObjects.append(
                            KeyframeObject(type: .cubic(CGSize(width: toX, height: toY), duration, nil, nil))
                        )
                        reviewId = reviewId + 1
                    }
                    Button("add linear animation") {
                        keyframeObjects.append(
                            KeyframeObject(type: .linear(CGSize(width: toX, height: toY), duration, nil))
                        )
                        reviewId = reviewId + 1
                    }
                    Button("add move animation") {
                        keyframeObjects.append(
                            KeyframeObject(type: .move(CGSize(width: toX, height: toY)))
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

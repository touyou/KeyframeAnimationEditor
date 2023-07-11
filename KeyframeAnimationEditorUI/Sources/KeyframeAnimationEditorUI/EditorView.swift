//
//  EditorView.swift
//  KeyframeAnimationEditor
//
//  Created by 藤井陽介 on 2023/06/27.
//

import SwiftUI
import KeyframeAnimationEditorData
import Charts
import Algorithms

public struct EditorView: View {
    @State var keyframeObjects: [KeyframeObject<CGSize>] = []
    @State var reviewId = 0

    @State var toX: CGFloat = 1.0
    @State var toY: CGFloat = 1.0
    @State var duration: Double = 2.0
    
    @State var scale: Double = 25.0
    
    var keyframeScaleXDatas: [PointData] {
        var time = 0.0
        var datas: [PointData] = []
        for i in 0..<keyframeObjects.count {
            switch keyframeObjects[i].type {
            case let .cubic(to, duration, _, _):
                time = time + duration
                datas.append(PointData(type: .cubic, to: Double(to.width), time: time))
            case let .linear(to, duration, _):
                time = time + duration
                datas.append(PointData(type: .linear, to: Double(to.width), time: time))
            case let .move(to):
                datas.append(PointData(type: .move, to: Double(to.width), time: time))
            case let .spring(to, duration, _, _):
                time = time + (duration ?? 0.5)
                datas.append(PointData(type: .spring, to: Double(to.width), time: time))
            }
        }
        return datas
    }
    var keyframeScaleYDatas: [PointData] {
        var time = 0.0
        var datas: [PointData] = []
        for i in 0..<keyframeObjects.count {
            switch keyframeObjects[i].type {
            case let .cubic(to, duration, _, _):
                time = time + duration
                datas.append(PointData(type: .cubic, to: Double(to.height), time: time))
            case let .linear(to, duration, _):
                time = time + duration
                datas.append(PointData(type: .linear, to: Double(to.height), time: time))
            case let .move(to):
                datas.append(PointData(type: .move, to: Double(to.height), time: time))
            case let .spring(to, duration, _, _):
                time = time + (duration ?? 0.5)
                datas.append(PointData(type: .spring, to: Double(to.height), time: time))
            }
        }
        return datas
    }
    
    enum ModeType: String {
        case spring
        case cubic
        case linear
        case move
    }
    
    struct PointData: Identifiable {
        let id: UUID = UUID()
        let type: ModeType
        let to: Double
        let time: Double
    }
    
    public init() {}
    
    public var body: some View {
        HStack {
            List {
                Section("control") {
                    HStack {
                        Text("幅のスケール: \(toX)")
                        Spacer()
                        Slider(value: $toX, in: 0.1...5.0)
                    }
                    HStack {
                        Text("高さのスケール: \(toY)")
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
                
                Section("Keyframe List") {
                    ForEach(keyframeObjects) { object in
                        Text(object.description)
                    }
                    if keyframeObjects.isEmpty {
                        ContentUnavailableView("まだアニメーションがありません", systemImage: "cat.circle.fill")
                    }
                }
                
                Section("settings") {
                    Slider(value: $scale, in: 5...50)
                }
            }
            .listStyle(.insetGrouped)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    VStack {
                        Path() { path in
                            path.move(to: CGPoint(x: 0.0, y: scale))
                            keyframeScaleXDatas.indexed().forEach { (index, keyframe) in
                                switch keyframe.type {
                                case .spring:
                                    let control = index > 0 ? CGPoint(x: keyframe.time * scale, y: keyframeScaleXDatas[index - 1].to * scale) : CGPoint(x: keyframe.time * scale, y: keyframe.to * scale)
                                    path.addQuadCurve(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale), control: control)
                                case .cubic:
                                    let control1 = index > 0 ? CGPoint(x: keyframeScaleXDatas[index - 1].time * scale, y: keyframeScaleXDatas[index - 1].to * scale) : CGPoint(x: keyframe.time * scale, y: keyframe.to * scale)
                                    let control2 = index < keyframeScaleXDatas.count - 1 ? CGPoint(x: keyframeScaleXDatas[index + 1].time * scale, y: keyframeScaleXDatas[index + 1].to * scale) : CGPoint(x: keyframe.time * scale, y: keyframe.to * scale)
                                    path.addCurve(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale), control1: control1, control2: control2)
                                case .linear:
                                    path.addLine(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale))
                                case .move:
                                    path.move(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale))
                                }
                            }
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        Text("幅のスケール")
                    }
                    VStack {
                        Path() { path in
                            path.move(to: CGPoint(x: 0.0, y: scale))
                            keyframeScaleYDatas.indexed().forEach { (index, keyframe) in
                                switch keyframe.type {
                                case .spring:
                                    let control = index > 0 ? CGPoint(x: keyframe.time * scale, y: keyframeScaleYDatas[index - 1].to * scale) : CGPoint(x: keyframe.time * scale, y: keyframe.to * scale)
                                    path.addQuadCurve(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale), control: control)
                                case .cubic:
                                    let control1 = index > 0 ? CGPoint(x: keyframeScaleYDatas[index - 1].time * scale, y: keyframeScaleYDatas[index - 1].to * scale) : CGPoint(x: keyframe.time * scale, y: keyframe.to * scale)
                                    let control2 = index < keyframeScaleXDatas.count - 1 ? CGPoint(x: keyframeScaleYDatas[index + 1].time * scale, y: keyframeScaleYDatas[index + 1].to * scale) : CGPoint(x: keyframe.time * scale, y: keyframe.to * scale)
                                    path.addCurve(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale), control1: control1, control2: control2)
                                case .linear:
                                    path.addLine(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale))
                                case .move:
                                    path.move(to: CGPoint(x: keyframe.time * scale, y: keyframe.to * scale))
                                }
                            }
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        Text("高さのスケール")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
        .ignoresSafeArea(.all)
    }
    
    func interpolationMethod(type: ModeType) -> InterpolationMethod {
        switch type {
        case .cubic:
            return .catmullRom
        case .linear:
            return .linear
        case .move:
            return .linear
        case .spring:
            return .cardinal
        }
    }
}

struct EditorView_Preview: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}

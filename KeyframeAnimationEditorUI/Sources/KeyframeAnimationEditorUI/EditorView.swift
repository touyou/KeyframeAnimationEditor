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

        var cgPoint: CGPoint {
            CGPoint(x: time, y: to)
        }
    }

    public init() {}
    
    public var body: some View {
        HStack {
            List {
                Section("control") {
                    HStack {
                        Text("幅のスケール: \(toX)")
                        Spacer()
                        Slider(value: $toX, in: 0.1...5.0, step: 0.05)
                    }
                    HStack {
                        Text("高さのスケール: \(toY)")
                        Spacer()
                        Slider(value: $toY, in: 0.1...5.0, step: 0.05)
                    }
                    HStack {
                        Text("継続時間: \(duration)")
                        Spacer()
                        Slider(value: $duration, in: 0.1...5.0, step: 0.05)
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

                Section("code") {
                    Text("""
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
      KeyframeTrack(\(#"\"#).scale) {
        \(keyframeObjects.map { keyframe in keyframe.code }.joined(separator: "\n        "))
      }
    }
""").font(.caption)
                }
            }
#if os(macOS)
            .listStyle(.sidebar)
#else
            .listStyle(.insetGrouped)
#endif
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
                            generatePath(path: &path, pointDatas: keyframeScaleXDatas)
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                        Text("幅のスケール")
                    }
                    VStack {
                        Path() { path in
                            path.move(to: CGPoint(x: 0.0, y: scale))
                            generatePath(path: &path, pointDatas: keyframeScaleYDatas)
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
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
    
    func generatePath(path: inout Path, pointDatas: [PointData]) {
        let size = CGSize(width: 0.1 * scale, height: 0.1 * scale)
        let origin = CGPoint(x: 0, y: scale)
        var prevStart: CGPoint? = nil
        for (index, keyframe) in pointDatas.indexed() {
            let prev = index > 0 ? pointDatas[index - 1] : nil
            let next = index < pointDatas.count - 1 ? pointDatas[index + 1] : nil
            
            let from: CGPoint
            if let prev = prev {
                from = prev.cgPoint * scale
            } else {
                from = origin
            }
            let to = keyframe.cgPoint * scale

            switch keyframe.type {
            case .spring:
                let control: CGPoint
                if let next = next, next.type != .move {
                    let target = velocityPoint(near: to, far: next.cgPoint * scale)
                    control = 3 * to - 2 * target
                } else {
                    control = CGPoint(x: (keyframe.time - 0.3) * scale, y: keyframe.to * scale)
                }
                path.addQuadCurve(to: to, control: control)
            case .cubic:
                let p0: CGPoint?
                if let prevStart = prevStart, prev?.type != .move {
                    p0 = velocityPoint(near: from, far: prevStart)
                } else {
                    p0 = nil
                }

                let p3: CGPoint?
                if let next = next, next.type != .move {
                    p3 = velocityPoint(near: to, far: next.cgPoint * scale)
                } else if p0 == nil {
                    p3 = CGPoint(x: (keyframe.time + 0.3) * scale, y: keyframe.to * scale)
                } else {
                    p3 = nil
                }
                let (control1, control2) = toBezier(fromCatmullP0: p0, p1: from, p2: to, p3: p3)
                path.addCurve(to: to, control1: control1, control2: control2)
            case .linear:
                path.addLine(to: to)
            case .move:
                path.move(to: to)
            }
            path.addEllipse(in: CGRect(origin: to - CGPoint(x: 0.1 * scale, y: 0.1 * scale) / 2, size: size))

            if index >= 1 {
                prevStart = from
            }
        }
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
    
    func toBezier(fromCatmullP0 p0: CGPoint?, p1: CGPoint, p2: CGPoint, p3: CGPoint?) -> (p1: CGPoint, p2: CGPoint) {
        var b, c: CGPoint
        if p0 == nil, let p3 = p3 {
            // 始点のt^2係数
            b = p1 / 2 - p2 + p3 / 2
            // 始点のt係数
            c = -3 * p1 / 2 + 2 * p2 - p3 / 2
        } else if p3 == nil, let p0 = p0 {
            // 終点のt^2係数
            b = p0 / 2 - p1 + p2 / 2
            // 終点のt係数
            c = -1 * p0 / 2 + p2 / 2
        } else if let p3 = p3, let p0 = p0 {
            // Catmull-Romのt^2係数
            b = p0 - 5 * p1 / 2 + 2 * p2 - p3 / 2
            // Catmull-Romのt係数
            c = -1 * p0 + p2 / 2
        } else {
            fatalError("invalid point")
        }
        let s1 = (c + 3 * p1) / 3
        let s2 = (b - 3 * p1 + 6 * s1) / 3
        return (s1, s2)
    }

    func velocityPoint(near p0: CGPoint, far p1: CGPoint) -> CGPoint {
        return (3 * p0 + p1) / 4
    }
}

struct EditorView_Preview: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}

extension KeyframeObject<CGSize> {
    public var code: String {
        switch type {
        case let .cubic(to, duration, _, _):
            let toStr = "CGSize(width: \(String(format: "%.2f", to.width)), height: \(String(format: "%.2f", to.height)))"
            let durationStr = String(format: "%.2f", duration)
            return "CubicKeyframe(\(toStr), duration: \(durationStr))"
        case let .linear(to, duration, _):
            let toStr = "CGSize(width: \(String(format: "%.2f", to.width)), height: \(String(format: "%.2f", to.height)))"
            let durationStr = String(format: "%.2f", duration)
            return "LinearKeyframe(\(toStr), duration: \(durationStr), timingCurve: .linear)"
        case let .move(to):
            let toStr = "CGSize(width: \(String(format: "%.2f", to.width)), height: \(String(format: "%.2f", to.height)))"
            return "MoveKeyframe(\(toStr))"
        case let .spring(to, duration, _, _):
            let toStr = "CGSize(width: \(String(format: "%.2f", to.width)), height: \(String(format: "%.2f", to.height)))"
            let durationStr = String(format: "%.2f", duration ?? 0.5)
            return "SpringKeyframe(\(toStr), duration: \(durationStr))"
        }
    }
}

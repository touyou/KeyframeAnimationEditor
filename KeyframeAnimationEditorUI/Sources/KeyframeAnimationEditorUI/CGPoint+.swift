//
//  CGPoint+.swift
//  
//
//  Created by 藤井陽介 on 2023/07/12.
//

import CoreGraphics

extension CGPoint{
  static func + (left: CGPoint, right: CGPoint) -> CGPoint {
    let x = left.x + right.x
    let y = left.y + right.y
    return CGPoint(x:x, y:y)
  }
  static func + (left: CGPoint, right: CGFloat) -> CGPoint {
    let x = left.x + right
    let y = left.y + right
    return CGPoint(x:x, y:y)
  }
  static func + (left: CGFloat, right: CGPoint) -> CGPoint {
    let x = left + right.x
    let y = left + right.y
    return CGPoint(x:x, y:y)
  }
  static func - (left: CGPoint, right: CGPoint) -> CGPoint {
    let x = left.x - right.x
    let y = left.y - right.y
    return CGPoint(x:x, y:y)
  }
  static func - (left: CGPoint, right: CGFloat) -> CGPoint {
    let x = left.x - right
    let y = left.y - right
    return CGPoint(x:x, y:y)
  }
  static func - (left: CGFloat, right: CGPoint) -> CGPoint {
    let x = left - right.x
    let y = left - right.y
    return CGPoint(x:x, y:y)
  }
  static func * (left: CGPoint, right: CGPoint) -> CGPoint {
    let x = left.x * right.x
    let y = left.y * right.y
    return CGPoint(x:x, y:y)
  }
  static func * (left: CGPoint, right: CGFloat) -> CGPoint {
    let x = left.x * right
    let y = left.y * right
    return CGPoint(x:x, y:y)
  }
  static func * (left: CGFloat, right: CGPoint) -> CGPoint {
    let x = left * right.x
    let y = left * right.y
    return CGPoint(x:x, y:y)
  }
  static func / (left: CGPoint, right: CGPoint) -> CGPoint {
    let x = left.x / right.x
    let y = left.y / right.y
    return CGPoint(x:x, y:y)
  }
  static func / (left: CGPoint, right: CGFloat) -> CGPoint {
    let x = left.x / right
    let y = left.y / right
    return CGPoint(x:x, y:y)
  }
  static func / (left: CGFloat, right: CGPoint) -> CGPoint {
    let x = left / right.x
    let y = left / right.y
    return CGPoint(x:x, y:y)
  }
}

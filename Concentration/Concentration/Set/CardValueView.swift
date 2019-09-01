//
//  CardValue.swift
//  Set
//
//  Created by Mitko Nikolov on 3/24/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class CardValueView: UIView {
  private var shape = Shape.circle
  private var shading = Shading.striped
  private var color = UIColor.red
  private let boundToRadiusRatio: CGFloat = 0.5

  private var minBound: CGFloat {
    if bounds.maxX<bounds.maxY {
      return bounds.maxX
    } else {
      return bounds.maxX
    }
  }

  private let green = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
  private let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
  private let blue = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

  init(frame: CGRect, _ shape: Shape, _ shading: Shading, _ color: UIColor) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear

    self.shape = shape
    self.shading = shading
    switch color {
    case .red: self.color = red
    case .green: self.color = green
    case .blue: self.color = blue
    default: break
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    var path = UIBezierPath()
    switch shape {
    case .circle:
      path.addArc(
        withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
        radius: minBound*boundToRadiusRatio,
        startAngle: 0,
        endAngle: 2*CGFloat.pi,
        clockwise: true
      )
    case .square:
      path = UIBezierPath(
        rect: CGRect(x: 0, y: 0, width: minBound, height: minBound)
      )
    default:
      path.move(to: CGPoint(x: bounds.midX, y: 0))
      path.addLine(to: CGPoint(x: 0, y: bounds.maxY))
      path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
      path.close()
    }
    path.addClip()
    path.lineWidth = 2
    color.setStroke()
    path.stroke()
    if shading == .full {
      color.setFill()
      path.fill()
    } else if shading == .striped {
      path.lineWidth = 1
      var stripingStep: CGFloat = 2
      if path.bounds.width<10 {
        stripingStep = 1
      }

      for lineNum in 1..<8 {
        path.move(
          to: CGPoint(x: CGFloat(lineNum) * (bounds.midX/stripingStep), y: 0)
        )
        path.addLine(
          to: CGPoint(
            x: CGFloat(lineNum) * (bounds.midX/stripingStep),
            y: bounds.maxY
          )
        )
      }
      path.stroke()
    }
  }

  override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    setNeedsDisplay()
  }
}

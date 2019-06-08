//
//  SetCardView.swift
//  Set
//
//  Created by John Smith on 3/20/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
  
  // view properties
  private var shape: Shape = Shape.square { didSet {setNeedsDisplay(); setNeedsLayout()} }
  @IBInspectable
  private var numberSymbols: Int = 3 { didSet {setNeedsDisplay(); setNeedsLayout()} }
  private var shading: Shading = Shading.striped { didSet {setNeedsDisplay(); setNeedsLayout()} }
  @IBInspectable
  private var color: UIColor = UIColor.red { didSet {setNeedsDisplay(); setNeedsLayout()} }
  @IBInspectable
  private var faceUp: Bool = true {
    didSet {
      setNeedsDisplay();
      setNeedsLayout()
    }
  }
  
  private let cardBodyColor = #colorLiteral(red: 1, green: 0.9989223741, blue: 0.9884161901, alpha: 1)
  private let cardOutlineColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
  private let highlightedColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
  private let successfulMatchColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
  private let failedMatchColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
  
  private let outlineStrokeWidth:CGFloat = 5
  private let cornerRadiusToSelfHeight: CGFloat = 0.15
  
  
  
  public var state = CardState.normal { didSet {setNeedsDisplay(); setNeedsLayout()} }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public init(frame: CGRect, shape: Shape, numSymbols: Int, shading: Shading, shapeColor: UIColor, faceUp: Bool) {
    super.init(frame: frame)
    self.shape = shape
    self.numberSymbols = numSymbols
    self.shading = shading
    self.color = shapeColor
    self.faceUp = faceUp
    self.state = CardState.normal
    self.backgroundColor = UIColor.clear
  }
  
  public func updateCard(
    shape: Shape,
    numberOfSymbols: Int,
    shading: Shading,
    color: UIColor,
    faceUp: Bool)
  {
    self.shape = shape
    self.numberSymbols = numberOfSymbols
    self.shading = shading
    self.color = color
    self.faceUp = faceUp
  }
  
  private var subviewSide:CGFloat {
    return bounds.maxY * CGFloat(subviewSideToSuperViewMaxYRatio)
  }
  
  private var subviewSideToSuperViewMaxYRatio = 0.20
  private var subviewSideSpacingRatio:CGFloat = 1.3
  
  private var firstSubviewYCoordinate: CGFloat {
    let viewsTotalHeight = CGFloat(numberSymbols) * subviewSide * subviewSideSpacingRatio
    return ((bounds.maxY - viewsTotalHeight) / 2)
  }
  
  private lazy var valuesViews = createCardValueViews()
  
  private func createCardValueViews() -> [UIView] {
    var valueViews = [UIView]()
    for _ in 0..<numberSymbols {
      let view = CardValueView(frame:
        CGRect(
          x: bounds.midX - (subviewSide/2),
          y: bounds.midY - (subviewSide/2),
          width: subviewSide,
          height: subviewSide),
        shape,
        shading,
        color)
      addSubview(view)
      valueViews.append(view)
    }
    return valueViews
  }
  
  // draw subviews
  override func layoutSubviews() {
    for valueSubview in valuesViews {
      valueSubview.removeFromSuperview()
    }
    valuesViews = createCardValueViews()
    super.layoutSubviews()
    for viewNumber in 0..<numberSymbols {
      valuesViews[viewNumber].frame.origin = CGPoint(x: ((bounds.midX)-(subviewSide/2)), y: (CGFloat(viewNumber) * subviewSide * subviewSideSpacingRatio) + firstSubviewYCoordinate)
    }
  }
  
  // draw the current view
  override func draw(_ rect: CGRect) {
    let cornerRadius = bounds.height * cornerRadiusToSelfHeight
    let roundedRect = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: cornerRadius)
    roundedRect.addClip()
    cardBodyColor.setFill()
    roundedRect.fill()
    cardOutlineColor.setStroke()
    roundedRect.lineWidth = outlineStrokeWidth
    switch state {
    case .highlighted: highlightedColor.setStroke()
    case .matchSuccessful: successfulMatchColor.setStroke()
    case .matchFailed: failedMatchColor.setStroke()
    default: break
    }
    roundedRect.stroke()
  }
}

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
  
  
  
  public var state = CardState.normal { didSet {setNeedsDisplay(); setNeedsLayout()} }
  
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
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
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
    let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
    roundedRect.addClip()
    UIColor.lightGray.setFill()
    roundedRect.fill()
    
    UIColor.lightGray.setStroke()
    roundedRect.lineWidth = 3
    if state == CardState.highlighted {
      UIColor.yellow.setStroke()
    }
    else if state == CardState.matchSuccessful {
      UIColor.green.setStroke()
    }
    else if state == CardState.matchFailed {
      UIColor.red.setStroke()
    }
    roundedRect.stroke()
  }
  
  // changes in orientation, font size, etc. are trait changes
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setNeedsDisplay()
    setNeedsLayout()
  }
}

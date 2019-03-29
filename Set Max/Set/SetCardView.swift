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
    private var faceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    private var subviewSide:CGFloat {
        return bounds.maxY * CGFloat(subviewSideToSuperViewMaxYRatio)
    }
    
    private var subviewSideToSuperViewMaxYRatio = 0.15
    private var subviewSideSpacingRatio:CGFloat = 1.3
    
    private var firstSubviewYCoordinate: CGFloat {
        let viewsTotalHeight = CGFloat(numberSymbols) * subviewSide * subviewSideSpacingRatio
        return ((bounds.maxY - viewsTotalHeight) / 2)
    }
    
    
    // subviews
//    private lazy var label = createCardLabel()
    
    private lazy var valuesViews = createCardValueViews()
    
    private func createCardValueViews() -> [UIView] {
        var valueViews = [UIView]()
        for _ in 0..<numberSymbols {
            let view = CardValueView(frame: CGRect(x: bounds.midX - (subviewSide/2), y: bounds.midY - (subviewSide/2), width: subviewSide, height: subviewSide), shape, shading, color)
            addSubview(view)
            valueViews.append(view)
        }
        return valueViews
    }
    
    // draw subviews
    override func layoutSubviews() {
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
    }
   
    // changes in orientation, font size, etc. are trait changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
}

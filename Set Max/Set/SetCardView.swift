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
    private var shape: Shape = Shape.triangle { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    private var numberSymbols: Int = 3 { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var shading: Shading = Shading.full { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    private var color: UIColor = UIColor.red { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    private var faceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    private var subviewSide:CGFloat = 50
    private var subviewSideSpacingRatio:CGFloat = 1.3
    
    
    // subviews
//    private lazy var label = createCardLabel()
    
    private lazy var valuesViews = createCardValueViews()
    private lazy var viewsContainer = createViewsContainer()

    private func createViewsContainer() -> UIView {
        return UIView(frame: CGRect(x: bounds.midX, y: bounds.midY, width: subviewSide, height: CGFloat(numberSymbols) * subviewSide * subviewSideSpacingRatio))
    }
    
    private func createCardValueViews() -> [UIView] {
        var valueViews = [UIView]()
        for elementNum in 0..<numberSymbols {
            let view = CardValueView(frame: CGRect(x: bounds.midX - (subviewSide/2), y: bounds.midY - (subviewSide/2), width: subviewSide, height: subviewSide), shape, shading, color)
            viewsContainer.addSubview(view)
            view.frame.origin = CGPoint(x: 0, y: 0 + (CGFloat(elementNum) * subviewSide * subviewSideSpacingRatio))
//            addSubview(view)
            valueViews.append(view)
        }
        addSubview(viewsContainer)
        return valueViews
    }
    
    // draw subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        viewsContainer.frame.origin = CGPoint(x: bounds.midX - (subviewSide/2), y: bounds.midY - (viewsContainer.frame.maxY/2))
//        for viewNumber in 0..<numberSymbols {
//            valuesViews[viewNumber].frame.origin = CGPoint(x: ((bounds.midX)-(subviewSide/2)), y: (CGFloat(viewNumber) * subviewSide * subviewSideSpacingRatio) + ((bounds.midY)-(subviewSide/2)))
//        }
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

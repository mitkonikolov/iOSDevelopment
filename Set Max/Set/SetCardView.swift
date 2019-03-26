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
    @IBInspectable
    private var symbol: String = "▲" { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    private var numberSymbols: Int = 3 { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var shading: Shading = Shading.full { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    private var color: UIColor = UIColor.red { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    private var faceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    // subviews
//    private lazy var label = createCardLabel()
    
    private lazy var value = createCardValue()

    
    private func createCardValue() -> UIView {
        let view = CardValueView(frame: CGRect(x: bounds.midX - 100, y: bounds.midY - 100, width: 200, height: 200))
        addSubview(view)
        return view
    }
    
    /// Generates an NSAttributedString with fonts enabling accessibility
    /// properties.
    func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle, .strokeColor: color])
    }
    
    /// Using the properties of this card view it generates a string that is
    /// used to create and return an NSAttributedString.
    private var cardValue: NSAttributedString {
        var text = ""
        for symbolNumber in 0..<numberSymbols {
            text += symbol
            if symbolNumber<(numberSymbols-1) {
                text += "\n"
            }
        }
        return centeredAttributedString(text, fontSize: 12)
    }
    
    // draw subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        value.frame.origin = CGPoint(x: (bounds.midX)-100, y: (bounds.midY)-100)
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
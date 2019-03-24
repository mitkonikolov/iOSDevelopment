//
//  SetCardView.swift
//  Set
//
//  Created by John Smith on 3/20/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    // view properties
    private var symbol = "▲" { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var numberSymbols = 3 { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var shading = Shading.full { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var color = UIColor.red { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var faceUp = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    // subviews
    private lazy var label = createCardLabel()
    
    /// Generates an NSAttributedString with fonts enabling accessibility
    /// properties.
    func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle])
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
    
    /// Creates the subview, sets its number of lines to be dynamic and adds it
    /// as a subview.
    private func createCardLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    /// Configures the text on the subview label of this view and sets its frame
    /// size and visibility.
    private func configureLabelTextSize() {
        label.attributedText = cardValue
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !faceUp
    }
    
    // draw subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabelTextSize()
        label.frame.origin = CGPoint(x: (bounds.midX) - (label.frame.width*0.5), y: (bounds.midY) - label.frame.height*0.5)
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

//
//  SetCardView.swift
//  Set
//
//  Created by John Smith on 3/20/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    private var symbol = "▲" { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var numberSymbols = 3 { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var shading = Shading.full { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var color = UIColor.red { didSet {setNeedsDisplay(); setNeedsLayout()} }
    private var faceUp = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle])
    }
    
    private lazy var textLabel = createCardLabel()
    
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
    
    private func createCardLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureLabelTextSize() {
        textLabel.attributedText = cardValue
        textLabel.frame.size = CGSize.zero
        textLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabelTextSize()
        textLabel.frame.origin = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        roundedRect.addClip()
        UIColor.lightGray.setFill()
        roundedRect.fill()
    }

}

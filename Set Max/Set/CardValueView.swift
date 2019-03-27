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
    private let boundToRadiusRatio:CGFloat = 0.5
    private var minBound:CGFloat {
        if(bounds.maxX<bounds.maxY) {
            return bounds.maxX
        }
        else {
            return bounds.maxX
        }
    }
    
    init(frame: CGRect, _ shape: Shape, _ shading: Shading, _ color: UIColor) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        self.shape = shape
        self.shading = shading
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        var path = UIBezierPath()
        switch shape {
        case .circle:
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: minBound*boundToRadiusRatio, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        case .square:
            path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: minBound, height: minBound))
        default:
            path.move(to: CGPoint(x: bounds.midX, y: 0))
            path.addLine(to: CGPoint(x: 0, y:bounds.maxY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            path.close()
        }
        path.addClip()
        path.lineWidth = 2
        color.setStroke()
        path.stroke()
        if(shading == .full) {
            color.setFill()
            path.fill()
        }
        else if(shading == .striped) {
            for lineNum in 1..<8 {
                path.move(to: CGPoint(x: CGFloat(lineNum) * (bounds.midX/4), y: 0))
                path.addLine(to: CGPoint(x: CGFloat(lineNum) * (bounds.midX/4), y: bounds.maxY))
            }
            path.stroke()
        }
    }
}

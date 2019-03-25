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
    private var shading = Shading.full
    private var numberObjects = 3
    private var color = UIColor.red
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        var path = UIBezierPath()
        
        switch shape {
        case .circle:
            for objNumber in 0..<numberObjects {
                path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY + CGFloat((objNumber*40))), radius: 10, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
                path
                
                
            }
//            path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        case .square:
            path = UIBezierPath(rect: CGRect(x: bounds.midX, y: bounds.midY, width: 20, height: 20))
        default:
            path = UIBezierPath(rect: CGRect(x: bounds.midX, y: bounds.midY, width: 50, height: 50))
        }
        color.setStroke()
        path.stroke()
        
        
    }
 

}

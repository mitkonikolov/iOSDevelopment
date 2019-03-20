//
//  SetCardView.swift
//  Set
//
//  Created by John Smith on 3/20/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    var faceUp = true {didSet: draw}
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        roundedRect.addClip()
        UIColor.lightGray.setFill()
        roundedRect.fill()
    }

}

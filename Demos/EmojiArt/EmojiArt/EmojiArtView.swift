//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Mitko Nikolov on 9/17/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

  var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}

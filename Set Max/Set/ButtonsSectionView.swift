//
//  ButtonsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/18/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ButtonsSectionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  override func draw(_ rect: CGRect) {
    self.layoutSubviews()
  }
  
  override func layoutSubviews() {
    var subviewsAlreadySet = 0
    for view in subviews {
      setFrameAndSizeFor(view, subviewsBefore: subviewsAlreadySet)
      view.setNeedsDisplay()
      subviewsAlreadySet += 1
    }
  }
  
  func setFrameAndSizeFor(_ subview: UIView, subviewsBefore: Int) {
    let widthForEachView = Int(self.bounds.width) / subviews.count
    subview.frame = CGRect(
      x: CGFloat(subviewsBefore * widthForEachView),
      y: self.bounds.origin.y,
      width: CGFloat(widthForEachView),
      height: self.bounds.height)
  }
}

//
//  CardsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/12/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class CardsSectionView: UIView {
  
  private let subviewAspectRatio:CGFloat = 3/5;
  
  var numberOfSubviews:Int {
    return subviews.count
  }
  
  var objectsOnTheGrid = 0
  
  var grid: Grid {
    var grid = Grid(
      layout: Grid.Layout.aspectRatio(subviewAspectRatio),
      frame: self.bounds)
    grid.cellCount = objectsOnTheGrid
    return grid
  }
  
  override func draw(_ rect: CGRect) {
    self.setNeedsLayout()
  }
  
  override func layoutSubviews() {
    for viewNumber in 0..<numberOfSubviews {
      if let cardPos = grid[viewNumber] {
        let view = self.subviews[viewNumber]
        let verticalChange = cardPos.height*0.02
        let horizontalChange = cardPos.width*0.02
        let newPos = cardPos.inset(
          by: UIEdgeInsets.init(
            top: verticalChange,
            left: horizontalChange,
            bottom: verticalChange,
            right: horizontalChange)
        )
        view.frame = newPos
        view.setNeedsDisplay()
        view.setNeedsLayout()
      }
    }
  }
  
  override func viewWithTag(_ tag: Int) -> UIView? {
    for subview in subviews {
      if subview.tag == tag {
        return subview
      }
    }
    return nil
  }
}

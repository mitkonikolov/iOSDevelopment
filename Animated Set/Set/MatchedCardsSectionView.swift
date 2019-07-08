//
//  MatchedCardsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/21/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class MatchedCardsSectionView: CardsSectionView {

  func removeAllSubviews() {
    subviews.forEach { subview in
      subview.removeFromSuperview()
    }
  }

  override func layoutSubviews() {
    var freeSpaceToAdd: CGFloat = 0
    if numberOfSubviews>0 {
      let lastCardPos = grid[numberOfSubviews-1]
      let freeSpace = bounds.width - lastCardPos!.maxX
      freeSpaceToAdd = freeSpace/2
    }
    for viewNumber in 0..<numberOfSubviews {
      if var cardPos = grid[viewNumber] {
        cardPos.origin = CGPoint(
          x: cardPos.origin.x + freeSpaceToAdd,
          y: cardPos.origin.y
        )
        let view = self.subviews[viewNumber]
        let verticalChange = cardPos.height*0.02
        let horizontalChange = cardPos.width*0.02
        let newPos = cardPos.inset(
          by: UIEdgeInsets.init(
            top: verticalChange,
            left: horizontalChange,
            bottom: verticalChange,
            right: horizontalChange
          )
        )
        view.frame = newPos
        view.setNeedsDisplay()
        view.setNeedsLayout()
      }
    }
  }
}

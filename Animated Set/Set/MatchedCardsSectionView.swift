//
//  MatchedCardsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/21/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class MatchedCardsSectionView: CardsSectionView {

  private let animator = UIViewPropertyAnimator(
    duration: 0.5,
    curve: .linear,
    animations: {}
  )
  
  private let fadeOutAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {})
  
  private var animationFinished = false
  
  func removeAllSubviews() {
    subviews.forEach { subview in
      subview.removeFromSuperview()
    }
  }
  
  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    animationFinished = false
  }

  override func layoutSubviews() {
    
    if animationFinished {
      return
    }
    

    let freeSpaceToAdd = calculateFreeSpaceToAdd()
    
    for viewNumber in 0..<numberOfSubviews {
      if var cardPos = grid[viewNumber] {
        cardPos.origin = CGPoint(
          x: cardPos.origin.x + freeSpaceToAdd,
          y: cardPos.origin.y
        )
        let view = self.subviews[viewNumber]
        let newPos = newPositionFrom(cardPos, freeSpaceToAdd)
        animateMatch(view, newPos)
      }
    }
    
    animator.startAnimation()
  }
  
  private func calculateFreeSpaceToAdd() -> CGFloat {
    var freeSpaceToAdd: CGFloat = 0
    if numberOfSubviews > 0 {
      let lastCardPos = grid[numberOfSubviews-1]
      let freeSpace = bounds.width - lastCardPos!.maxX
      freeSpaceToAdd = freeSpace/2
    }
    return freeSpaceToAdd
  }
  
  private func newPositionFrom(_ cardPos: CGRect, _ freeSpaceToAdd: CGFloat) -> CGRect {
    let verticalChange = cardPos.height*0.08
    let horizontalChange = cardPos.width*0.08
    return cardPos.inset(
      by: UIEdgeInsets.init(
        top: verticalChange,
        left: horizontalChange,
        bottom: verticalChange,
        right: horizontalChange
      )
    )
  }
  
  private func animateMatch(_ view: UIView, _ newPos: CGRect) {
    view.frame = newPos
    view.transform = CGAffineTransform(scaleX: 0, y: 0)
    animator.addAnimations {
      view.transform = CGAffineTransform.identity
    }
    animator.addCompletion({ [unowned self] _ in
      self.sendMatchedToPile(view)
    })
  }
  
  private func sendMatchedToPile(_ view: UIView) -> Timer {
    return Timer.scheduledTimer(
      withTimeInterval: 1,
      repeats: false,
      block: { [unowned self] _ in
        UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: 0.3,
          delay: 0,
          options: [],
          animations: {
            view.frame.origin = CGPoint(x: 80, y: 380)
          },
          completion: { _ in
//            view.frame.size = CGSize(width: 0, height: 0)
            self.animationFinished = true
            self.removeAllSubviews()
            self.superview?.sendSubviewToBack(self)
          }
        )
      }
    )
  }
}

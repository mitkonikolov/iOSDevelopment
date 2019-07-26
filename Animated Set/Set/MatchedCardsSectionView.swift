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
    duration: constants.propertyAnimationDuration,
    curve: .linear,
    animations: {}
  )
  
  struct constants {
    static let propertyAnimationDuration = 0.5
    static let cardSizeDecrease:CGFloat = 0.08
    static let sendToPileAnimationDuration = 0.3
    static let sendToPileAnimationDelay = Double(1)
    static let freeSpaceRatio = CGFloat(2)
  }
  
  private var animationFinished = false
  
  private var matchPilePoint: CGPoint?
  
  public func setMatchPileFrame(_ frame: CGRect) {
    matchPilePoint = frame.origin
  }
  
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
      freeSpaceToAdd = freeSpace/constants.freeSpaceRatio
    }
    return freeSpaceToAdd
  }
  
  private func newPositionFrom(_ cardPos: CGRect, _ freeSpaceToAdd: CGFloat) -> CGRect {
    let verticalChange = cardPos.height * constants.cardSizeDecrease
    let horizontalChange = cardPos.width * constants.cardSizeDecrease
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
  
  private func sendMatchedToPile(_ view: UIView) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: constants.sendToPileAnimationDuration,
      delay: constants.sendToPileAnimationDelay,
      options: [],
      animations: { [unowned self] in
        if self.matchPilePoint != nil {
          view.frame.origin = self.matchPilePoint!
        }
    },
      completion: { _ in
        self.animationFinished = true
        self.removeAllSubviews()
        self.superview?.sendSubviewToBack(self)
    }
    )
  }
}

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
  
  private let fadingOutAnimator = UIViewPropertyAnimator(
    duration: constants.sendToPileAnimationDuration,
    curve: .linear,
    animations: {}
  )
  
  struct constants {
    static let propertyAnimationDuration = 0.93
    static let cardSizeDecrease:CGFloat = 0.08
    static let sendToPileAnimationDuration = 0.92
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
        animateFold(view)
      }
    }
    
    animator.startAnimation()
    fadingOutAnimator.startAnimation(afterDelay: animator.duration)
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
//    view.alpha = 0
    view.frame = newPos
    view.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
    animator.addAnimations {
      view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
//      view.transform = CGAffineTransform.identity
    }
//    animator.addCompletion { (position) in
//      self.fadingOutAnimator.startAnimation()
//    }
    
    
//    animator.addCompletion { (position) in
//      UIViewPropertyAnimator.runningPropertyAnimator(
//        withDuration: 0.8,
//        delay: 0,
//        options: [],
//        animations: {view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)})
//    }
    
//    UIViewPropertyAnimator.runningPropertyAnimator(
//      withDuration: 0.8,
//      delay: 0,
//      options: [],
//      animations: {view.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)},
//      completion: {position in
//        UIViewPropertyAnimator.runningPropertyAnimator(
//          withDuration: 0.8,
//          delay: 0,
//          options: [],
//          animations: {view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)})
//    })
    
    
    
    
//    animator.addAnimations {
//      //      view.alpha = 1
//      view.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
//    }
//    animator.addCompletion( { _ in
//      UIViewPropertyAnimator.runningPropertyAnimator(
//        withDuration: 0.8,
//        delay: 0,
//        options: [],
//        animations: {
//        view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//        })
//    })

//    animator.addCompletion({ [unowned self] _ in
//      self.fadingOutAnimator.startAnimation(afterDelay: constants.sendToPileAnimationDelay)
//    })
  }
  
  private func animateFold(_ view:UIView) {
    fadingOutAnimator.addAnimations {
      if self.matchPilePoint != nil {
        view.frame.origin = self.matchPilePoint!
        view.transform = CGAffineTransform.identity.scaledBy(x: 0.4, y: 0.4)
      }
    }
    fadingOutAnimator.addCompletion({ _ in
      self.animationFinished = true;
      self.removeAllSubviews()
      self.superview?.sendSubviewToBack(self)
    })
    
//    fadingOutAnimator.addCompletion( { _ in
//        self.animationFinished = true
//        self.removeAllSubviews()
//        self.superview?.sendSubviewToBack(self)
//      }
//    )
  }
}

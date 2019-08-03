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
  
  private lazy var dynamicAnimator = UIDynamicAnimator(referenceView: self.superview!)
  
  private var collisionBehavior: UICollisionBehavior {
    let behavior = UICollisionBehavior()
    behavior.translatesReferenceBoundsIntoBoundary = true
    dynamicAnimator.addBehavior(behavior)
    return behavior
  }
  
  private var dynamicBehavior: UIDynamicItemBehavior {
    let behavior = UIDynamicItemBehavior()
    behavior.allowsRotation = false
    behavior.elasticity = constants.collisionElasticity
    behavior.friction = constants.collisionFriction
    dynamicAnimator.addBehavior(behavior)
    return behavior
  }
  
  static var pushAngle: CGFloat {
    return 2*CGFloat.pi * CGFloat.random(in: 0.1 ... 1)
  }
  
  static var pushMagnitude:CGFloat {
    return CGFloat(1) * CGFloat.random(in: 2.1 ... 10.1)
  }
  
  struct constants {
    static let propertyAnimationDuration = 0.83
    static let cardSizeDecrease:CGFloat = 0.08
    static let sendToPileAnimationDuration = 0.62
    static let bouncingBehaviorDuration = 1.3
    static let freeSpaceRatio = CGFloat(2)
    static let preMatchRenderScale = CGFloat(0.25)
    static let postMatchRenderScale = CGFloat(0.35)
    static let collisionElasticity = CGFloat(1)
    static let collisionFriction = CGFloat(0)
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
        addToBehaviors(view)
      }
    }
    
    animator.startAnimation()
    Timer.scheduledTimer(
      withTimeInterval: animator.duration + constants.bouncingBehaviorDuration,
      repeats: false,
      block: { _ in
        self.dynamicAnimator.removeAllBehaviors()
        self.fadingOutAnimator.startAnimation()
      })
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
    view.transform = CGAffineTransform.identity.scaledBy(
      x: constants.preMatchRenderScale,
      y: constants.preMatchRenderScale)
    animator.addAnimations {
      view.transform = CGAffineTransform.identity
    }
  }
  
  private func animateFold(_ view:UIView) {
    fadingOutAnimator.addAnimations {
      if self.matchPilePoint != nil {
        view.frame.origin = self.matchPilePoint!
      }
    }
    fadingOutAnimator.addCompletion({ _ in
      self.animationFinished = true;
      self.removeAllSubviews()
      self.superview?.sendSubviewToBack(self)
    })
  }
  
  private func addToBehaviors(_ view: UIView) {
    collisionBehavior.addItem(view)
    dynamicBehavior.addItem(view)
    let push = UIPushBehavior(items: [view], mode: .instantaneous)
    push.angle = MatchedCardsSectionView.pushAngle
    push.magnitude = MatchedCardsSectionView.pushMagnitude
    push.action = { [unowned push] in
      push.dynamicAnimator?.removeBehavior(push)
    }
    dynamicAnimator.addBehavior(push)
  }
}

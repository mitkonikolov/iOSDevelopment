//
//  CardsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/12/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class CardsSectionView: UIView {

  private let subviewAspectRatio: CGFloat = 3/5;
  private let insetBy: CGFloat = 0.02

  var numberOfSubviews: Int {
    return subviews.count
  }

  var objectsOnTheGrid = 0
  
  private var animations:[UIViewPropertyAnimator] = []
  
  private var dealingCardsAnimationState = UIViewAnimatingState.inactive

  var grid: Grid {
    var grid = Grid(
      layout: Grid.Layout.aspectRatio(subviewAspectRatio),
      frame: self.bounds
    )
    grid.cellCount = objectsOnTheGrid
    return grid
  }
  
  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    view.frame = CGRect(x: 70, y: 785, width: 0, height: 0)
  }

  override func layoutSubviews() {
    if self.bounds.height == 0 {
      return
    }
    
    checkWhetherNewAnimationShouldStart()
    
    for viewNumber in 0..<numberOfSubviews {
      if let cardPos = grid[viewNumber] {
        let view = self.subviews[viewNumber]
        let newFramePos = insetPositionFrom(cardPos)
        changeFrameFor(view, newFramePos)
      }
    }
    
    if dealingCardsAnimationState == .inactive {
      setAnimationOrder()
      animations[0].startAnimation()
      dealingCardsAnimationState = .active
    }

  }
  
  private func checkWhetherNewAnimationShouldStart() {
    for view in subviews {
      if let card = view as? SetCardView {
        // the animation has stopped but there is a card that will need to be animated
        if !card.faceUp && dealingCardsAnimationState == .stopped {
          animations = []
          dealingCardsAnimationState = .inactive
          return
        }
      }
    }
  }
  
  private func insetPositionFrom(_ cardPos: CGRect) -> CGRect {
    let verticalChange = cardPos.height * insetBy
    let horizontalChange = cardPos.width * insetBy
    return cardPos.inset(
      by: UIEdgeInsets.init(
        top: verticalChange,
        left: horizontalChange,
        bottom: verticalChange,
        right: horizontalChange
      ))
  }
  
  private func changeFrameFor(_ view: UIView, _ newFrame: CGRect) {
    // the first display of the cards, so they are animated
    if dealingCardsAnimationState == .inactive {
      animations.append(animateMovingCard(card: view, newFrame))
    }
    else if dealingCardsAnimationState == .stopped {
      view.frame = newFrame
    }
  }
  
  private func setAnimationOrder() {
    for animation in 0..<(animations.count) {
      if animation == animations.count-1 {
        animations[animation].addCompletion({ [unowned self] _ in
          self.dealingCardsAnimationState = .stopped
          //self.setNeedsLayout()
        })
      }
      else {
        animations[animation].addCompletion({ [unowned self ] _ in
          self.animations[animation+1].startAnimation()
        })
      }
    }
  }
  
  private func animateMovingCard(card view: UIView, _ newFrame: CGRect) -> UIViewPropertyAnimator {
    let setCard = view as! SetCardView
    let propertyAnimator = UIViewPropertyAnimator(
      duration: 0.4,
      curve: .easeOut,
      animations: {
        setCard.frame = newFrame
    }
    )
    propertyAnimator.addCompletion({ _ in
      if !setCard.faceUp {
        UIView.transition(
          with: setCard,
          duration: 0.4,
          options: [.transitionFlipFromLeft],
          animations: {
            setCard.faceUp = true
        })
      }
    })
    return propertyAnimator
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

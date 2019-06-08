//
//  ContainerView.swift
//  Set
//
//  Created by Mitko Nikolov on 4/2/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ContainerView: UIView {
  
  // height constants for matched section
  // max height as sectionHeight/containerViewHeight
  private let matchedMaxProportionalHeight:CGFloat = 0.2
  private let matchedAbsHeightMax:CGFloat = 200
  private let matchedAbsHeightMin:CGFloat = 100
  // height constants for buttons section
  private let buttonsMaxProportionalHeight:CGFloat = 0.1
  private let buttonsAbsHeightMax:CGFloat = 50
  private let buttonsAbsHeightMin:CGFloat = 40
  // priority used for lower priority constraints
  private let proportionConstraintPriority:Float = 750
  
  private var cardsSection:UIView?
  private var matchedSection:UIView?
  private var buttonsSection:UIView?
  
  func bringMatchedToFront() {
    bringSubviewToFront(matchedSection!)
  }
  
  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    switch view {
    case is MatchedCardsSectionView:
      matchedSection = view
    case is ButtonsSectionView:
      buttonsSection = view
    default:
      cardsSection = view
    }
    if subviews.count == 3 {
      subviews.forEach { view in
        setConstraintsFor(view)
      }
    }
  }
  
  override func layoutSubviews() {
    subviews.forEach { view in
      view.setNeedsLayout()
    }
  }
  
  func removeAllSubviews() {
    subviews.forEach { view in
      view.removeFromSuperview()
    }
  }
  
  private func setConstraintsFor(_ view: UIView) {
    let margins = self.layoutMarginsGuide
    setDefaultConstraints(view)
    switch view {
    case is MatchedCardsSectionView:
      setConstraints(
        forMatchedOrButtonSection: view,
        maxProportionalHeight: matchedMaxProportionalHeight,
        bottomAnchor: buttonsSection!.topAnchor,
        topAnchor: margins.topAnchor,
        verticalCenterAnchor: margins.centerYAnchor,
        maxHeight: matchedAbsHeightMax,
        minHeight: matchedAbsHeightMin)
      sendSubviewToBack(view)
    case is CardsSectionView:
      NSLayoutConstraint.activate(
        [
          view.topAnchor.constraint(equalTo: margins.topAnchor),
          view.bottomAnchor.constraint(equalTo: buttonsSection!.topAnchor)
        ]
      )
    case is ButtonsSectionView:
      setConstraints(
        forMatchedOrButtonSection: view,
        maxProportionalHeight: buttonsMaxProportionalHeight,
        bottomAnchor: margins.bottomAnchor,
        topAnchor: cardsSection!.bottomAnchor,
        verticalCenterAnchor: margins.centerYAnchor,
        maxHeight: buttonsAbsHeightMax,
        minHeight: buttonsAbsHeightMin)
    default:
      break
    }
  }
  
  private func setDefaultConstraints(_ view: UIView) {
    let margins = self.layoutMarginsGuide
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        view.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
      ]
    )
  }
  
  private func setConstraints(
    forMatchedOrButtonSection view: UIView,
    maxProportionalHeight heightMultiplier: CGFloat,
    bottomAnchor: NSLayoutYAxisAnchor,
    topAnchor: NSLayoutYAxisAnchor,
    verticalCenterAnchor: NSLayoutYAxisAnchor,
    maxHeight: CGFloat,
    minHeight: CGFloat)
  {
    assert(
      view is MatchedCardsSectionView || view is ButtonsSectionView,
      "setConstraints(forMatchedOrButtonsSection ...): view must be of type " +
      "MatchedCardsSectionView or ButtonsSectionView")
    // for small screens this raises the max height by using proportions
    let heightProportion = view.heightAnchor.constraint(
      lessThanOrEqualTo: layoutMarginsGuide.heightAnchor,
      multiplier: heightMultiplier)
    heightProportion.priority = UILayoutPriority(
      rawValue: proportionConstraintPriority)
    
    NSLayoutConstraint.activate(
      [
        heightProportion,
        // large screens: limits the max height by using an absolute limit
        view.heightAnchor.constraint(
          lessThanOrEqualToConstant: maxHeight),
        view.heightAnchor.constraint(
          greaterThanOrEqualToConstant: minHeight)
      ]
    )
    
    if view is ButtonsSectionView {
      view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      view.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    else {
      view.centerYAnchor.constraint(equalTo: verticalCenterAnchor)
        .isActive = true
    }
  }

}

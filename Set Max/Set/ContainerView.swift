//
//  ContainerView.swift
//  Set
//
//  Created by Mitko Nikolov on 4/2/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ContainerView: UIView {
  
  // height ratios constants - initialized based on orientation
  private var topSectionHeightToOverallHeight:CGFloat = 0.8
  private var middleSectionHeightToOverallHeight:CGFloat = 0.1
  private var bottomSectionHeightToOverallHeight:CGFloat = 0.1
  
  private var cardsSection:UIView?
  private var matchedSection:UIView?
  private var buttonsSection:UIView?
  
  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    if view is MatchedCardsSectionView {
      matchedSection = view
      matchedSection?.backgroundColor = .green
    }
    else if view is ButtonsSectionView {
      buttonsSection = view
    }
    else {
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
  
  private func setConstraintsFor(_ view: UIView) {
    let margins = self.layoutMarginsGuide
    setDefaultConstraints(view)
    switch view {
    case is MatchedCardsSectionView:
      setMatchedSectionConstraints(view as! MatchedCardsSectionView)
    case is CardsSectionView:
      NSLayoutConstraint.activate(
        [
          view.topAnchor.constraint(equalTo: margins.topAnchor),
          view.bottomAnchor.constraint(equalTo: matchedSection!.topAnchor)
        ]
      )
    case is ButtonsSectionView:
      let heightProportion = view.heightAnchor.constraint(lessThanOrEqualTo: margins.heightAnchor, multiplier: 0.1)
      heightProportion.priority = UILayoutPriority(rawValue: 750)
      NSLayoutConstraint.activate(
        [
          view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
          heightProportion,
          view.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
          view.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
          view.topAnchor.constraint(equalTo: matchedSection!.bottomAnchor)
        ]
      )
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
  
  // TODO check if this function name follows name style guides cause it includes a class type in it
  private func setMatchedSectionConstraints(_ view: MatchedCardsSectionView) {
    let margins = self.layoutMarginsGuide
    
    // for small screens this raises the max height by using proportions
    let heightProportion = view.heightAnchor.constraint(lessThanOrEqualTo: margins.heightAnchor, multiplier: 0.2)
    heightProportion.priority = UILayoutPriority(rawValue: 750)
    NSLayoutConstraint.activate(
      [
        view.bottomAnchor.constraint(equalTo: buttonsSection!.topAnchor),
        view.topAnchor.constraint(equalTo: cardsSection!.bottomAnchor),
        heightProportion,
        // for large screens this limits the max height by using an absolute limit
        view.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
      ]
    )
  }

}

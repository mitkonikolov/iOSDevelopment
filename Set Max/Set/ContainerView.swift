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
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    // portrait mode
    if traitCollection.verticalSizeClass == .regular {
      topSectionHeightToOverallHeight = 0.8
      middleSectionHeightToOverallHeight = 0.1
      bottomSectionHeightToOverallHeight = 0.1
    } // landscape mode
    else {
      topSectionHeightToOverallHeight = 0.65
      middleSectionHeightToOverallHeight = 0.25
      bottomSectionHeightToOverallHeight = 0.1
    }
  }
  
  // subvies used as sections for cards and buttons
  private var topSection:CGRect  {
    return CGRect(
      x: 0,
      y: 0,
      width: self.bounds.width,
      height: self.bounds.height * topSectionHeightToOverallHeight)
  }
  
  private var middleSection:CGRect  {
    return CGRect(
      x: 0,
      y: self.bounds.height * topSectionHeightToOverallHeight,
      width: self.bounds.width,
      height: self.bounds.height * middleSectionHeightToOverallHeight)
  }
  
  private var bottomSection: CGRect {
    return CGRect(
      x: 0,
      y: self.bounds.height * (topSectionHeightToOverallHeight +
        middleSectionHeightToOverallHeight),
      width: self.bounds.width,
      height: self.bounds.height * bottomSectionHeightToOverallHeight)
  }
  
  override func addSubview(_ view: UIView) {
    setFrameFor(view)
    super.addSubview(view)
  }
  
  override func layoutSubviews() {
    subviews.forEach { view in
      setFrameFor(view)
      view.setNeedsLayout()
    }
  }
  
  private func setFrameFor(_ view: UIView) {
    switch view {
    case is MatchedCardsSectionView: view.frame = middleSection
    case is CardsSectionView: view.frame = topSection
    case is ButtonsSectionView: view.frame = bottomSection
    default:
      break
    }
  }
}

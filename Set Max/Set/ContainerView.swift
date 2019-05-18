//
//  ContainerView.swift
//  Set
//
//  Created by Mitko Nikolov on 4/2/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ContainerView: UIView {
  
  // height ratios constants
  private let cardsSectionHeightToOverallHeight:CGFloat = 0.9
  private var buttonsSectionHeightToOverallHeight:CGFloat {
    return 1-cardsSectionHeightToOverallHeight
  }
  
  // subvies used as sections for cards and buttons
  private var cardsSection:CGRect  {
    return CGRect(
      x: 0,
      y: 0,
      width: self.bounds.width,
      height: self.bounds.height * cardsSectionHeightToOverallHeight)
  }
  

  private var buttonsSection: CGRect {
    return CGRect(
      x: 0,
      y: self.bounds.height * cardsSectionHeightToOverallHeight,
      width: self.bounds.width,
      height: self.bounds.height * buttonsSectionHeightToOverallHeight)
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
    case is CardsSectionView: view.frame = cardsSection
    case is ButtonsSectionView: view.frame = buttonsSection
    default:
      break
    }
  }
}

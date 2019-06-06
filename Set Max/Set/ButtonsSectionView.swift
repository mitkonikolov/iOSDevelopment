//
//  ButtonsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/18/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ButtonsSectionView: UIView {
  
  private var scoreLabel: UILabel?
  private var dealCardsButton: UIButton?
  private var newGameButton: UIButton?
  
  
  private let scoreMaxProportionalWidth:CGFloat = 0.3
  private let dealCardsMaxProportionalWidth:CGFloat = 0.4
  private let newGameMaxProportionalWidth:CGFloat = 0.3
  
  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    if subviews.count==3 {
      setLayoutConstraints()
    }
  }
  
  func addLabelSubview(_ labelView: UILabel) {
    scoreLabel = labelView
    addSubview(labelView)
  }
  
  func addButtonSubview(_ buttonView: UIButton) {
    if buttonView.title(for: .normal)!.lowercased().contains("new") {
      newGameButton = buttonView
    }
    else {
      dealCardsButton = buttonView
    }
    addSubview(buttonView)
  }
  
  override func layoutSubviews() {
    subviews.forEach { view in
      view.setNeedsDisplay()
    }
  }
  
  private func setLayoutConstraints() {
    let margins = self.layoutMarginsGuide
    subviews.forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
      view.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        .isActive = true
    }
    NSLayoutConstraint.activate(
      [
        scoreLabel!.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
        scoreLabel!.trailingAnchor.constraint(equalTo: dealCardsButton!.leadingAnchor),
        scoreLabel!.widthAnchor.constraint(
          lessThanOrEqualTo: margins.widthAnchor,
          multiplier: scoreMaxProportionalWidth),
        dealCardsButton!.leadingAnchor.constraint(
          equalTo: scoreLabel!.trailingAnchor),
        dealCardsButton!.widthAnchor.constraint(
          lessThanOrEqualTo: margins.widthAnchor,
          multiplier: dealCardsMaxProportionalWidth),
        newGameButton!.trailingAnchor.constraint(
          equalTo: margins.trailingAnchor),
        newGameButton!.leadingAnchor.constraint(
          equalTo: dealCardsButton!.trailingAnchor),
        newGameButton!.widthAnchor.constraint(
          lessThanOrEqualTo: margins.widthAnchor,
          multiplier: newGameMaxProportionalWidth)
      ]
    )
    
  }
}

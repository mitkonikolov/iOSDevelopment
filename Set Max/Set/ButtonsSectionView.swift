//
//  ButtonsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/18/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ButtonsSectionView: UIView {

  
  
//  override func draw(_ rect: CGRect) {
//    self.layoutSubviews()
//  }
  
  private var scoreLabel: UILabel?
  private var dealCardsButton: UIButton?
  private var newGameButton: UIButton?
  
  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    if subviews.count==3 {
      setLayoutConstraints()
    }
  }
  
  func addLabelSubview(_ labelView: UILabel) {
    addSubview(labelView)
    scoreLabel = labelView
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
    }
    NSLayoutConstraint.activate(
      [
        scoreLabel!.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
        scoreLabel!.trailingAnchor.constraint(equalTo: dealCardsButton!.leadingAnchor),
        dealCardsButton!.leadingAnchor.constraint(
          equalTo: scoreLabel!.trailingAnchor),
        newGameButton!.trailingAnchor.constraint(
          equalTo: margins.trailingAnchor),
        newGameButton!.leadingAnchor.constraint(
          equalTo: dealCardsButton!.trailingAnchor)
      ]
    )
    
  }
}

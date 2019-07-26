//
//  ButtonsSectionView.swift
//  Set
//
//  Created by Mitko Nikolov on 5/18/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ButtonsSectionView: UIView {

  private var dealCardsButton: UIButton?
  private var newGameButton: UIButton?
  private let matchedCardsPile = UIButton()

  let dealCardsMaxProportionalWidth: CGFloat = 0.32
  private let matchedCardsPileMaxProportionalWidth: CGFloat = 0.32
  private let newGameMaxProportionalWidth: CGFloat = 0.32

  private let expectedSubviews = 2

  override func addSubview(_ view: UIView) {
    super.addSubview(view)
    if subviews.count == expectedSubviews {
      super.addSubview(matchedCardsPile)
      matchedCardsPile.backgroundColor = .brown
      matchedCardsPile.isHidden = true
      setLayoutConstraints()
    }
  }

  func addButtonSubview(_ buttonView: UIButton) {
    if buttonView.title(for: .normal)!.lowercased().contains("new") {
      newGameButton = buttonView
    } else {
      dealCardsButton = buttonView
      dealCardsButton!.backgroundColor = .brown
    }
    addSubview(buttonView)
  }
  
  public func showMatchedPile() {
    matchedCardsPile.isHidden = false
  }

  private func setLayoutConstraints() {
    let margins = self.layoutMarginsGuide
    subviews.forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
      view.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive
        = true
    }
    NSLayoutConstraint.activate(
      [
        dealCardsButton!.leadingAnchor.constraint(
          equalTo: margins.leadingAnchor
        ),
        dealCardsButton!.widthAnchor.constraint(
          lessThanOrEqualTo: margins.widthAnchor,
          multiplier: dealCardsMaxProportionalWidth
        ),
        matchedCardsPile.leadingAnchor.constraint(
          equalTo: dealCardsButton!.trailingAnchor),
        matchedCardsPile.widthAnchor.constraint(
          lessThanOrEqualTo: margins.widthAnchor,
          multiplier: matchedCardsPileMaxProportionalWidth),
        newGameButton!.trailingAnchor.constraint(
          equalTo: margins.trailingAnchor
        ),
        newGameButton!.leadingAnchor.constraint(
          equalTo: matchedCardsPile.trailingAnchor
        ),
        newGameButton!.widthAnchor.constraint(
          lessThanOrEqualTo: margins.widthAnchor,
          multiplier: newGameMaxProportionalWidth
        )
      ]
    )
  }
}

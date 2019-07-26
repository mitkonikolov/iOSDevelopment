//
//  ViewController.swift
//  Set
//
//  Created by Mitko Nikolov on 1/21/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  private var game = Set()

  private let numberOfCardsToDealAtOnce = 3
  private let numberOfCardsToStart = 12
  private let numberOfCardsToMakeAMatch = 3
  // 81 cards tagged 0..80
  private let highestPossibleTag = 80
  
  private let timeToPauseBeforeShowingMatchedPile = 1.85

  private var cardsSectionView: CardsSectionView?
  private var buttonsSectionView: ButtonsSectionView?
  private var matchedSectionView: MatchedCardsSectionView?

  private let cardAspectRatio: CGFloat = 3/5;
  
  private var needToUpdateDealPileLocation = true
  private var needToUpdateMatchPileLocation = true
  
  private var dealPileFrame: CGRect {
    if containerView != nil && buttonsSectionView != nil {
      let y = containerView.bounds.height *
        (1 - (containerView.buttonsMaxProportionalHeight/2))
      let x = containerView.bounds.width * (buttonsSectionView!.dealCardsMaxProportionalWidth/2)
      return CGRect(x: x, y: y, width: 0, height: 0)
    }
    
    return CGRect(x: 0, y: 0, width: 0, height: 0)
  }
  
  private var matchPileFrame: CGRect {
    let dealPile = dealPileFrame
    return CGRect(
      x: dealPile.origin.x * 2.7,
      y: dealPile.origin.y * 0.55,
      width: 0,
      height: 0)
  }

  private var numberOfCards: Int {
    return game.cardsPlaying.count
  }

  private var cardAt: [Card] {
    return game.cardsPlaying
  }

  private var scoreLabel = UILabel()

  private var dealThreeCardsButton: UIButton {
    let dealCards = UIButton()
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(dealThreeCards)
    )
    dealCards.setTitle("Deal \(numberOfCardsToDealAtOnce) Cards", for: .normal)
    dealCards.setTitleColor(.black, for: .normal)
    dealCards.addGestureRecognizer(tap)
    dealCards.titleLabel!.font = UIFont.preferredFont(forTextStyle: .body)
    dealCards.titleLabel!.adjustsFontSizeToFitWidth = true
    dealCards.contentMode = .redraw

    return dealCards
  }

  private var newGameButton: UIButton {
    let button = UIButton()
    let tap = UITapGestureRecognizer(target: self, action: #selector(newGame))
    button.setTitle("New Game", for: .normal)
    button.addGestureRecognizer(tap)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel!.font = UIFont.preferredFont(forTextStyle: .body)
    button.titleLabel!.adjustsFontSizeToFitWidth = true
    button.contentMode = .redraw

    return button
  }

  @objc private func selectCard(_ sender: UITapGestureRecognizer) {
    if let cardView = sender.view as? SetCardView {
      let cardNumber = cardView.tag

      // less than 3 cards and deselecting one of them
      if game.selectedCardsIndices.count < 3
        && game.selectedCardsIndices.contains(cardNumber) {
        game.deselectCard(number: cardNumber)
      }// selecting a card that is not part of a match
      else if cardView.state != CardState.matchSuccessful {
        game.selectCard(at: cardNumber)
      }

      // 3 cards have formed a match
      if game.selectedCardsFormAMatch {
        if needToUpdateMatchPileLocation {
          matchedSectionView?.setMatchPileFrame(matchPileFrame)
          needToUpdateMatchPileLocation = false
        }
        matchSuccessfulUpdateViews()
        containerView.bringMatchedToFront()
        Timer.scheduledTimer(
          withTimeInterval: timeToPauseBeforeShowingMatchedPile,
          repeats: false,
          block: { _ in
          self.buttonsSectionView?.showMatchedPile()
        })
      }
    }
    updateAllCardViewsBorderColors()
    scoreLabel.text = "Score: \(game.score)"
    containerView.setNeedsLayout()
  }

  @objc private func dealThreeCards(_ sender: UITapGestureRecognizer) {
    if !game.deck.isEmpty {
      game.dealThreeCards()
      if needToUpdateDealPileLocation {
        cardsSectionView?.setDealPile(dealPileFrame)
        needToUpdateDealPileLocation = false
      }
      addCardsViewsToCardsSectionView()
      containerView.setNeedsLayout()
      containerView.setNeedsDisplay()
    }
  }

  @objc private func shuffleCardViews(_ sender: UIRotationGestureRecognizer) {
    if sender.state == .ended {
      var cardTagsAndNumbers: [Int] = Array(0..<game.cardsPlaying.count)
      var randomIndex = 0

      while !cardTagsAndNumbers.isEmpty {
        randomIndex = Int.random(in: 0..<cardTagsAndNumbers.count)
        let tagNumber = cardTagsAndNumbers.remove(at: randomIndex)
        if cardTagsAndNumbers.isEmpty {
          break
        }
        let randomIndexTwo = Int.random(in: 0..<cardTagsAndNumbers.count)
        let otherTagNumber = cardTagsAndNumbers.remove(at: randomIndexTwo)

        cardsSectionView!.exchangeSubview(
          at: tagNumber,
          withSubviewAt: otherTagNumber
        )
      }
    }
  }

  @IBOutlet weak var containerView: ContainerView! {
    didSet {
      let swipe = UISwipeGestureRecognizer(
        target: self,
        action: #selector(newGame)
      )
      swipe.direction = .down
      containerView.addGestureRecognizer(swipe)

      let rotation = UIRotationGestureRecognizer(
        target: self,
        action: #selector(shuffleCardViews)
      )
      containerView.addGestureRecognizer(rotation)

      let touch = UITapGestureRecognizer(
        target: self,
        action: #selector(resetMatchedSectionTapAction)
      )
      containerView.addGestureRecognizer(touch)
    }
  }

  @objc private func resetMatchedSectionTapAction(_ sender: UIButton) {
    resetMatchedSection()
  }

  private func resetMatchedSection() {
    if matchedSectionView?.subviews.count == 3 {
      matchedSectionView!.removeAllSubviews()
      containerView.sendSubviewToBack(matchedSectionView!)
    }
  }

  @objc private func newGame(_ sender: UIButton) {
    game = Set()
    containerView.removeAllSubviews()
    cardsSectionView = CardsSectionView()
    buttonsSectionView = ButtonsSectionView()
    matchedSectionView = MatchedCardsSectionView()
    
    addAllSectionsToContainerView()
    
    setUpScoreLabel()
    setUpButtonsSection()
    setUpCardsSection()
    setUpMatchedSection()
    
  }

  private func setUpCardsSection() {
    cardsSectionView!.contentMode = .redraw
    cardsSectionView!.tag = Int.max
    cardsSectionView!.setDealPile(dealPileFrame)

    for _ in 0..<numberOfCardsToStart/numberOfCardsToDealAtOnce {
      game.dealThreeCards()
    }

    addCardsViewsToCardsSectionView()
  }

  private func setUpButtonsSection() {
    buttonsSectionView!.contentMode = .redraw
    addButtonsToButtonsSectionView()
  }

  private func setUpMatchedSection() {
    matchedSectionView!.contentMode = .redraw
    matchedSectionView!.objectsOnTheGrid = numberOfCardsToMakeAMatch
    matchedSectionView!.setMatchPileFrame(matchPileFrame)
  }

  private func addAllSectionsToContainerView() {
    containerView.addSubview(scoreLabel)
    containerView.addSubview(cardsSectionView!)
    containerView.addSubview(matchedSectionView!)
    containerView.addSubview(buttonsSectionView!)
  }

  private func setUpScoreLabel() {
    scoreLabel.textAlignment = NSTextAlignment.center
    scoreLabel.backgroundColor = UIColor.clear
    scoreLabel.font = UIFont.preferredFont(forTextStyle: .body)
    scoreLabel.adjustsFontSizeToFitWidth = true
    scoreLabel.contentMode = .redraw
    scoreLabel.text = "Score: \(game.score)"
  }

  /// Updates all setCardViews' border colors based on card state in the model.
  private func updateAllCardViewsBorderColors() {
    for cardTagAndNumber in 0..<game.cardsPlaying.count {
      let cardView = cardsSectionView!.viewWithTag(cardTagAndNumber)
      if let setCardView = cardView as? SetCardView {
        getPlayingCardBorderColor(for: cardTagAndNumber, withView: setCardView)
      }
    }
  }

  func addButtonsToButtonsSectionView() {
    buttonsSectionView!.addButtonSubview(dealThreeCardsButton)
    buttonsSectionView!.addButtonSubview(newGameButton)
  }

  func addCardsViewsToCardsSectionView() {
    cardsSectionView!.objectsOnTheGrid = numberOfCards
    var firstNewCardsViewIndex = 0
    if numberOfCards > numberOfCardsToStart {
      firstNewCardsViewIndex = numberOfCards-numberOfCardsToDealAtOnce
    }
    for cardNum in firstNewCardsViewIndex..<numberOfCards {
      let newPos = CGRect(x: 0, y: 0, width: 0, height: 0)
      let cardView = getCardViewFrom(frame: newPos, cardNumber: cardNum)
      cardView.contentMode = .redraw
      cardsSectionView!.addSubview(cardView)
    }
  }

  private func getCardViewFrom(
    frame position: CGRect,
    cardNumber: Int
  ) -> SetCardView {
    let modelCard = cardAt[cardNumber]
    let shape = getShapeFrom(property: modelCard.symbol)
    let shading = getShadingFrom(property: modelCard.shading)
    let color = getColorFrom(property: modelCard.color)
    // create the card view
    let setCard = SetCardView(
      frame: position,
      shape: shape,
      numSymbols: modelCard.number.rawValue,
      shading: shading,
      shapeColor: color,
      faceUp: false
    )
    getPlayingCardBorderColor(for: cardNumber, withView: setCard)
    // add the tap recognizer to the view
    let tapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(selectCard)
    )
    tapRecognizer.numberOfTapsRequired = 1
    setCard.addGestureRecognizer(tapRecognizer)
    setCard.tag = cardNumber
    return setCard
  }

  private func getShapeFrom(property shapeAsProperty: Property) -> Shape {
    if let shapeFromProperty = Shape(rawValue: shapeAsProperty.rawValue) {
      return shapeFromProperty
    }
    // there has been an error in the mapping of raw values - attempting to use
    // default shape
    // TODO: it would be better to log this somehow
    return Shape.circle
  }

  private func getShadingFrom(property shadingAsProperty: Property) -> Shading {
    if let shadingFromProperty = Shading(rawValue: shadingAsProperty.rawValue) {
      return shadingFromProperty
    }
    // there has been an error in the mapping of raw values - attempting to use
    // default shape
    // TODO: it would be better to log this somehow
    return Shading.full
  }

  private func getColorFrom(property colorAsProperty: Property) -> UIColor {
    switch colorAsProperty {
    case .one:
      return UIColor.red
    case .two:
      return UIColor.green
    default:
      return UIColor.blue
    }
  }

  private func getPlayingCardBorderColor(
    for index: Int,
    withView cardView: SetCardView
  ) {
    if game.selectedCardsIndices.contains(index) {
      if game.selectedCardsFormAMatch {
        cardView.state = CardState.matchSuccessful
      } else if game.selectedCardsIndices.count == 3
        && !game.selectedCardsFormAMatch
      {
        cardView.state = CardState.matchFailed
      } else {
        cardView.state = CardState.highlighted
      }
    } else {
      cardView.state = CardState.normal
    }
  }

  /// Updates the setCardViews with new values from the model.
  ///
  /// It assumes that within the model, the deck is still not empty and
  /// therefore there are new cards at the same indices of the old matched
  /// cards. It should not be called if the deck is full and cards will be
  /// removed. It sets the card to be face down so the card is "dealt" again.
  ///
  /// - Parameter matchedViewsTags: tags of setCardViews forming a match
  private func updateMatchedCardsViewsWithNewFaces(_ matchedViewsTags: [Int]) {
    for cardTagAndNumber in matchedViewsTags {
      let cardView = cardsSectionView!.viewWithTag(cardTagAndNumber)
        as! SetCardView
      let modelCard = cardAt[cardTagAndNumber]
      cardView.updateCard(
        shape: getShapeFrom(property: modelCard.symbol),
        numberOfSymbols: modelCard.number.rawValue,
        shading: getShadingFrom(property: modelCard.shading),
        color: getColorFrom(property: modelCard.color),
        faceUp: false
      )
    }
  }

  // figure out how to make a copy of an object instead of making a new one
  private func addMatchedCardsToMatchedSection(_ matchedViewsTags: [Int]) {
    for cardTagAndNumber in matchedViewsTags {
      let cardView = getCardViewFrom(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        cardNumber: cardTagAndNumber
      )
      // set the card to be face up
      cardView.faceUp = true
      // invert the tag so matched cards have negative tags - 1
      // 0 -> -1
      // 1 -> -2
      cardView.tag = (cardView.tag * (-1)) - 1
      matchedSectionView!.addSubview(cardView)
    }
    matchedSectionView!.setNeedsLayout()
  }

  private func removeMatchedViewsAndUpdateAllViewsTags(
    _ matchedViewsTags: [Int]
  ) {
    // the matched cards will be substituted by new ones so tags do not need to
    // be updated
    if !game.deck.isEmpty {
      return
    }

    var firstMatchedCardTag = Int.max
    var secondMatchedCardTag = 0
    var thirdMatchedCardTag = 0
    for tag in matchedViewsTags {
      // tag < first
      if tag < firstMatchedCardTag {
        thirdMatchedCardTag = secondMatchedCardTag
        secondMatchedCardTag = firstMatchedCardTag
        firstMatchedCardTag = tag
      }  // first < tag < second
      else if tag < secondMatchedCardTag {
        thirdMatchedCardTag = secondMatchedCardTag
        secondMatchedCardTag = tag
      }  // second < tag
      else {
        thirdMatchedCardTag = tag
      }
    }

    var decreaseTagBy = 1
    for tag in firstMatchedCardTag...highestPossibleTag {
      if tag == (secondMatchedCardTag + 1) || tag == (thirdMatchedCardTag + 1) {
        decreaseTagBy += 1
      }
      if let cardView = cardsSectionView!.viewWithTag(tag) {
        if tag == firstMatchedCardTag || tag == secondMatchedCardTag || tag
          == thirdMatchedCardTag
        {
          cardView.removeFromSuperview()
        } else {
          cardView.tag = cardView.tag - decreaseTagBy
        }
      }
    }
    cardsSectionView?.objectsOnTheGrid = game.cardsPlaying.count
    cardsSectionView?.setNeedsLayout()
  }

  private func matchSuccessfulUpdateViews() {
    let matchingCardsIndices = game.selectedCardsIndices
    addMatchedCardsToMatchedSection(matchingCardsIndices)
    let theDeckWasEmptyBeforeThisMatch = game.deck.isEmpty
    game.replaceMatchedPlayingCardsWithRandomOnes()
    if theDeckWasEmptyBeforeThisMatch {
      removeMatchedViewsAndUpdateAllViewsTags(matchingCardsIndices)
    } else {
      updateMatchedCardsViewsWithNewFaces(matchingCardsIndices)
      matchedSectionView?.layoutIfNeeded()
      cardsSectionView?.setNeedsLayout()
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if needToUpdateDealPileLocation == false {
      needToUpdateDealPileLocation = true
    }
    if needToUpdateMatchPileLocation == false {
      needToUpdateMatchPileLocation = true
    }
  }

}

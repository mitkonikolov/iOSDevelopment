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
  
  private var cardsSectionView: CardsSectionView?
  private var buttonsSectionView: ButtonsSectionView?
  private var matchedSectionView: MatchedCardsSectionView?
  
  
  private let cardAspectRatio:CGFloat = 3/5;
  
  private let scoreLabelWidthToPanelRectWidth:CGFloat = 0.35
  
  private var numberOfCards: Int {
    get {
      return game.cardsPlaying.count
    }
    
  }
  
  private var cardAt: [Card] {
    return game.cardsPlaying
  }
  
  private var scoreLabel = UILabel()
  
  private var dealThreeCardsButton:UIButton {
    let dealCards = UIButton()
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(dealThreeCards))
    dealCards.setTitle("Deal \(numberOfCardsToDealAtOnce) Cards", for: .normal)
    dealCards.addGestureRecognizer(tap)
    dealCards.contentMode = .redraw
    return dealCards
  }
  
  private var newGameButton:UIButton {
    let button = UIButton()
    let tap = UITapGestureRecognizer(target: self, action: #selector(newGame))
    button.setTitle("New Game", for: .normal)
    button.addGestureRecognizer(tap)
    button.contentMode = .redraw
    return button
  }
  
  @objc private func selectCard(_ sender: UITapGestureRecognizer) {
    if let cardView = sender.view as? SetCardView {
      let cardNumber = cardView.tag
      // selecting any card other than one from the matched section
      if cardNumber>0 {
        matchedSectionView?.removeAllSubviews()
      }
      
      // less than 3 cards and deselecting one of them
      if game.selectedCardsIndices.count < 3 &&
        game.selectedCardsIndices.contains(cardNumber) {
        game.deselectCard(number: cardNumber)
      }
      // selecting a card that is not part of a match
      else if cardView.state != CardState.matchSuccessful {
        game.selectCard(at: cardNumber)
      }
      // 3 cards have formed a match
      if game.selectedCardsFormAMatch {
        let matchingCardsIndices = game.selectedCardsIndices
        addMatchedCardsToMatchedSection(matchingCardsIndices)
        game.replaceMatchedPlayingCardsWithRandomOnes()
        updateMatchedCardsViewsWithNewFaces(matchingCardsIndices)
        cardsSectionView?.setNeedsLayout()
      }
    }
    updateCardState()
    scoreLabel.text = "Score: \(game.score)"
    containerView.setNeedsLayout()
    containerView.setNeedsDisplay()
  }
  
  
  @objc private func dealThreeCards(_ sender: UITapGestureRecognizer) {
    game.dealThreeCards()
    addCardsToCardsSectionView()
    containerView.setNeedsLayout()
    containerView.setNeedsDisplay()
  }
  
  
  @IBOutlet weak var containerView: ContainerView! {
    didSet {
      let swipe = UISwipeGestureRecognizer(
        target: self,
        action: #selector(newGame)
      )
      swipe.direction = .down
      containerView.addGestureRecognizer(swipe)
    }
  }
  
  @objc private func newGame(_ sender: UIButton) {
    game = Set()
    containerView.subviews.forEach { view in
      view.removeFromSuperview()
    }
    setUpScoreLabel()
    
    cardsSectionView = CardsSectionView()
    cardsSectionView!.contentMode = .redraw
    
    buttonsSectionView = ButtonsSectionView()
    buttonsSectionView!.contentMode = .redraw
    
    matchedSectionView = MatchedCardsSectionView()
    matchedSectionView!.contentMode = .redraw
    matchedSectionView!.objectsOnTheGrid = 3
    //    matchedSectionView = UILabel()
    //    matchedSectionView!.contentMode = .redraw
    //    matchedSectionView!.text = ""
    //    matchedSectionView!.textAlignment = .center
    //    matchedSectionView!.adjustsFontSizeToFitWidth = true
    //    matchedSectionView!.textColor = .white
    //    matchedSectionView!.font = UIFont.preferredFont(forTextStyle: .body)
    
    
    for _ in 0..<numberOfCardsToStart/numberOfCardsToDealAtOnce {
      game.dealThreeCards()
    }
    
    addCardsToCardsSectionView()
    addButtonsToButtonsSectionView()
    containerView.addSubview(cardsSectionView!)
    containerView.addSubview(matchedSectionView!)
    containerView.addSubview(buttonsSectionView!)
    containerView.setNeedsLayout()
  }
  
  private func setUpScoreLabel() {
    scoreLabel.textAlignment = NSTextAlignment.center
    scoreLabel.textColor = UIColor.white
    scoreLabel.backgroundColor = UIColor.clear
    scoreLabel.adjustsFontSizeToFitWidth = true
    scoreLabel.contentMode = .redraw
    scoreLabel.text = "Score: \(game.score)"
  }
  
  private func updateCardState() {
    for cardNum in 0..<game.cardsPlaying.count {
      for setCardSubview in cardsSectionView!.subviews {
        if (setCardSubview.tag == cardNum) {
          getPlayingCardBorderColor(
            for: cardNum,
            withView: setCardSubview as! SetCardView)
        }
      }
      //      let currView = cardsSectionView!.subviews[cardNum] as! SetCardView
      //      getPlayingCardBorderColor(for: cardNum, withView: currView)
    }
  }
  
  func addButtonsToButtonsSectionView() {
    buttonsSectionView!.addSubview(scoreLabel)
    buttonsSectionView!.addSubview(dealThreeCardsButton)
    buttonsSectionView!.addSubview(newGameButton)
  }
  
  func addCardsToCardsSectionView() {
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
    ) -> SetCardView
  {
    let modelCard = cardAt[cardNumber]
    let shape = getShapeFrom(property: modelCard.symbol)
    let shading = getShadingFrom(property: modelCard.shading)
    let color = getColorFrom(property: modelCard.color)
    // create the card view
    let setCard =  SetCardView(
      frame: position,
      shape: shape,
      numSymbols: modelCard.number.rawValue,
      shading: shading,
      shapeColor: color,
      faceUp: true)
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
    switch(colorAsProperty) {
    case .one:
      return UIColor.red
    case .two:
      return UIColor.green
    default:
      return UIColor.blue
    }
  }
  
  private func getPlayingCardBorderColor(
    for index:Int,
    withView cardView: SetCardView)
  {
    if game.selectedCardsIndices.contains(index) {
      if game.selectedCardsFormAMatch {
        cardView.state = CardState.matchSuccessful
      }
      else if game.selectedCardsIndices.count == 3 &&
        !game.selectedCardsFormAMatch
      {
        cardView.state = CardState.matchFailed
      }
      else {
        cardView.state = CardState.highlighted
      }
    }
    else {
      cardView.state = CardState.normal
    }
  }
  
  private func updateMatchedCardsViewsWithNewFaces(_ matchedViewsTags: [Int]) {
    for cardNumber in matchedViewsTags {
      let cardView = cardsSectionView?.subviews[cardNumber] as! SetCardView
      let modelCard = cardAt[cardNumber]
      cardView.updateCard(
        shape: getShapeFrom(property: modelCard.symbol),
        numberOfSymbols: modelCard.number.rawValue,
        shading: getShadingFrom(property: modelCard.shading),
        color: getColorFrom(property: modelCard.color),
        faceUp: true
      )
    }
  }
  
  // figure out how to make a copy of an object instead of making a new one
  private func addMatchedCardsToMatchedSection(_ matchedViewsTags: [Int]) {
    for cardNumber in matchedViewsTags {
      let cardView = getCardViewFrom(frame: CGRect(x: 0, y: 0, width: 0, height: 0), cardNumber: cardNumber)
      // invert the tag so matched cards have negative tags
      cardView.tag = cardView.tag * (-1)
      matchedSectionView!.addSubview(cardView)
    }
    matchedSectionView!.setNeedsLayout()
  }
  
}

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
    private var shapes = ["▲","●","■"]
    private var fill = [-5, 5, 0.35]
    private var colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    
    
    private let rectForCardsHeightRatio:CGFloat = 0.9
    private var rectForPanelHeightRatio:CGFloat {
        return 1-rectForCardsHeightRatio
    }
    
    private var cardsRect:CGRect  {
        return CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height*rectForCardsHeightRatio)
    }
    
    private var panelRect: CGRect {
        return CGRect(x: 0, y: containerView.bounds.height*rectForCardsHeightRatio, width: containerView.bounds.width, height: containerView.bounds.height*rectForPanelHeightRatio)
    }
    
    private let scoreLabelWidthToPanelRectWidth:CGFloat = 0.35
    
    private var numberOfCards: Int {
        return game.cardsPlaying.count
    }
    private var grid: Grid {
        var grid = Grid(layout: Grid.Layout.aspectRatio(3/5), frame: cardsRect)
        grid.cellCount = numberOfCards
        return grid
    }
    
    private var cardAt: [Card] {
        return game.cardsPlaying
    }
    
    private var scoreLabel:UILabel {
        let scoreLab = UILabel(frame: CGRect(origin: panelRect.origin, size: CGSize(width: panelRect.width*scoreLabelWidthToPanelRectWidth, height: panelRect.height)))
        scoreLab.textAlignment = NSTextAlignment.center
        scoreLab.textColor = UIColor.white
        scoreLab.backgroundColor = UIColor.clear
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.contentMode = .redraw
        scoreLab.text = "Score: \(game.score)"
        return scoreLab
    }
    
    private var dealThreeCardsButton:UIButton {
        let dealCards = UIButton(frame: CGRect(origin: CGPoint(x: panelRect.origin.x+scoreLabel.bounds.width, y: panelRect.origin.y), size: CGSize(width: panelRect.width*scoreLabelWidthToPanelRectWidth, height: panelRect.height)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(dealThreeCards))
        dealCards.setTitle("Deal 3 Cards", for: .normal)
        dealCards.addGestureRecognizer(tap)
        dealCards.contentMode = .redraw
        return dealCards
    }
    
    private var newGameButton:UIButton {
        let button = UIButton(frame: CGRect(origin: CGPoint(x: dealThreeCardsButton.frame.origin.x+dealThreeCardsButton.bounds.width, y: panelRect.origin.y), size: CGSize(width: panelRect.width*(1-(2*scoreLabelWidthToPanelRectWidth)), height: panelRect.height)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(newGame))
        button.setTitle("New Game", for: .normal)
        button.addGestureRecognizer(tap)
        button.contentMode = .redraw
        return button
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @objc private func selectCard(_ sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? SetCardView {
            let cardNumber = cardView.tag
            if game.selectedCardsFormAMatch {
                if !game.selectedCardsIndices.contains(cardNumber) {
                    game.replaceMatchedPlayingCardsWithRandomOnes()
                    game.selectCard(at: cardNumber)
                }
                setUpCardsViewsInContainerView()
            }
            else if game.selectedCardsIndices.count < 3 &&
                game.selectedCardsIndices.contains(cardNumber) {
                game.deselectCard(number: cardNumber)
                updateSelectedCardsViews()
            }
            else {
                game.selectCard(at: cardNumber)
                setUpCardsViewsInContainerView()
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        containerView.setNeedsLayout()
        containerView.setNeedsDisplay()
    }
    
    @objc private func dealThreeCards(_ sender: UITapGestureRecognizer) {
        game.dealThreeCards()
        setUpCardsViewsInContainerView()
        containerView.setNeedsLayout()
        containerView.setNeedsDisplay()
    }
    
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(newGame))
            swipe.direction = .down
            containerView.addGestureRecognizer(swipe)
        }
    }
    
    @objc private func newGame(_ sender: UIButton) {
        game = Set()
        for _ in 0..<4 {
            game.dealThreeCards()
        }

        setUpCardsViewsInContainerView()
        setUpPanelViewsInContainerView()
        containerView.setNeedsLayout()
        containerView.setNeedsDisplay()
    }
    
    private func setUpNewGameButtonAndAddToContainerView() {
        containerView.addSubview(newGameButton)
        newGameButton.setNeedsDisplay()
    }
    
    private func setUpDealCardsButtonAndAddToContainerView() {
        containerView.addSubview(dealThreeCardsButton)
        dealThreeCardsButton.setNeedsDisplay()
    }
    
    private func updateSelectedCardsViews() {
        for cardNum in game.selectedCardsIndices {
            let currView = containerView.subviews[cardNum] as! SetCardView
            getPlayingCardBorderColor(for: cardNum, withView: currView)
        }
    }
    
    private func removeCurrentCardSubviewsFromContainerView() {
        // there are subviews that need to be removed to add the new ones
        for currCardView in containerView.subviews {
            if currCardView is SetCardView {
                currCardView.removeFromSuperview()
            }
        }
    }
    
    private func removePanelViewsSubviewsFromContainerView() {
        // there are subviews that need to be removed to add the new ones
        for currCardView in containerView.subviews {
            if !(currCardView is SetCardView) {
                currCardView.removeFromSuperview()
            }
        }
    }
    
    private func setUpPanelViewsInContainerView() {
        removePanelViewsSubviewsFromContainerView()
        containerView.addSubview(scoreLabel)
        containerView.addSubview(dealThreeCardsButton)
        containerView.addSubview(newGameButton)
    }
    
    private func setUpCardsViewsInContainerView() {
        removeCurrentCardSubviewsFromContainerView()
        
        for cardNum in 0..<numberOfCards {
            if let cardPos = grid[cardNum] {
                let verticalChange = cardPos.height*0.02
                let horizontalChange = cardPos.width*0.02
                let newPos = cardPos.inset(by: UIEdgeInsets.init(top: verticalChange, left: horizontalChange, bottom: verticalChange, right: horizontalChange))
                let cardView = getCardViewFrom(frame: newPos, cardNumber: cardNum)
                cardView.contentMode = .redraw
                containerView.addSubview(cardView)
            }
        }

    }
    
    private func getCardViewFrom(frame position: CGRect, cardNumber: Int) -> SetCardView {
        let modelCard = cardAt[cardNumber]
        let shape = getShapeFrom(property: modelCard.symbol)
        let shading = getShadingFrom(property: modelCard.shading)
        let color = getColorFrom(property: modelCard.color)
        // create the card view
        let setCard =  SetCardView(frame: position, shape: shape, numSymbols: modelCard.number.rawValue, shading: shading, shapeColor: color, faceUp: true)
        getPlayingCardBorderColor(for: cardNumber, withView: setCard)
        // add the tap recognizer to the view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCard))
        tapRecognizer.numberOfTapsRequired = 1
        setCard.addGestureRecognizer(tapRecognizer)
        setCard.tag = cardNumber
        return setCard
    }
    
    
    private func getShapeFrom(property shapeAsProperty: Property) -> Shape {
        if let shapeFromProperty = Shape(rawValue: shapeAsProperty.rawValue) {
            return shapeFromProperty
        }
        // there has been an error in the mapping of raw values - attempting to use default shape
        // TODO: it would be better to log this somehow
        return Shape.circle
    }
    
    private func getShadingFrom(property shadingAsProperty: Property) -> Shading {
        if let shadingFromProperty = Shading(rawValue: shadingAsProperty.rawValue) {
            return shadingFromProperty
        }
        // there has been an error in the mapping of raw values - attempting to use default shape
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
    
    private func getPlayingCardBorderColor(for index:Int, withView cardView: SetCardView) {
        if game.selectedCardsIndices.contains(index) {
            if game.selectedCardsFormAMatch {
                cardView.state = CardState.matchSuccessful
            }
            else if game.selectedCardsIndices.count == 3 && !game.selectedCardsFormAMatch {
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpCardsViewsInContainerView()
        setUpPanelViewsInContainerView()
        containerView.setNeedsLayout()
        containerView.setNeedsDisplay()
    }
    
}

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
    private let maxNumberCards = 24
    private var moreCardsCanBeShown: Bool {
        get {
            return game.cardsPlaying.count < maxNumberCards
        }
    }
    private var shapes = ["▲","●","■"]
    private var fill = [-5, 5, 0.35]
    private var colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender), game.cardsPlaying.indices.contains(cardNumber) {
            game.selectCard(at: cardNumber)
            match = false
            if game.selectedCardsFormAMatch {
                match = true
                game.removeMatchedPlayingCards()
                game.dealThreeCards()
            }
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Set()
        for card in cardButtons {
            card.setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.disabled)
        }
        for _ in 0..<4 {
            game.dealThreeCards()
        }
        updateViewFromModel()
    }
    
    @IBAction func dealCards(_ sender: Any) {
        if moreCardsCanBeShown, !game.deck.isEmpty {
            game.dealThreeCards()
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var matchedLabel: UILabel!
    
    var match = false
    
    private func updateViewFromModel() {
        if match {
            matchedLabel.text = "✅"
        }
        else {
            matchedLabel.text = ""
        }
        for index in cardButtons.indices {
            if game.cardsPlaying.indices.contains(index) {
                let card = game.cardsPlaying[index]
                let attributes: [NSAttributedString.Key:Any]
                if card.shading.rawValue < 3 {
                    attributes = [
                        .foregroundColor: colors[card.color.rawValue-1],
                        .strokeWidth: fill[card.shading.rawValue-1]
                    ]
                }
                else {
                    attributes = [
                        .foregroundColor: colors[card.color.rawValue-1].withAlphaComponent(CGFloat(fill[card.shading.rawValue-1]))
                    ]
                }
                var text = ""
                for _ in 0..<card.number.rawValue {
                    text += shapes[card.symbol.rawValue-1]
                }
                let attributedString = NSAttributedString(string: text, attributes: attributes)
                cardButtons[index].setAttributedTitle(attributedString, for: UIControl.State.normal)
                cardButtons[index].layer.borderWidth = 3.0
                if game.selectedCardsIndices.contains(index) {
                    if game.selectedCardsIndices.count == 3 && !game.selectedCardsFormAMatch {
                        cardButtons[index].layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    }
                    else {
                        cardButtons[index].layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    }
                }
                else {
                    cardButtons[index].layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                }
            }
            else {
                cardButtons[index].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
            }
        }
    }
}

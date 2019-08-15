//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Mitko Nikolov on 12/24/17.
//  Copyright © 2017 Mitko Nikolov. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    private let emojiThemes = [["🎃", "😈", "💀", "🧟‍♀️", "🧛‍♂️", "🍭", "🍬", "👻", "☠️", "👽"],
                       ["😀", "😁", "😝", "😎", "😳", "😬", "🤠", "🤣", "😋", "🤓", "🧐","😘"],
                       ["🐶", "🐱", "🦊", "🐻", "🐭", "🐵", "🦁", "🐼", "🐹", "🐰", "🐯","🐷"],
                       ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🥊", "🏓", "🏐", "🏒", "🎱", "🏸","⛸"],
                       ["🍉", "🥑", "🍅", "🍊", "🍋", "🍏", "🌽", "🥕", "🥔", "🥦", "🥥","🍍"],
                       ["🚗", "🚌", "🚎", "🏎", "🚓", "✈️", "🛳", "🚁", "🚀", "🚅", "🚃","⛵️"]]
    private let colorSchemes = [(backgroundColor: UIColor.white, cardColor: UIColor.orange),
                            (backgroundColor: UIColor.white, cardColor: UIColor.blue),
                            (backgroundColor: UIColor.brown, cardColor: UIColor.red),
                            (backgroundColor: UIColor.red, cardColor: UIColor.black),
                            (backgroundColor: UIColor.blue, cardColor: UIColor.white),
                            (backgroundColor: UIColor.green, cardColor: UIColor.gray)]
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var score: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else {
            print("cardButtons does not contain this card")
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        emojiChoices = emojiThemes[emojiThemes.count.arc4random]
        let theme = colorSchemes[colorSchemes.count.arc4random]
        // reset the association between cards and emojis
        emoji = [Card:String]()
        // set all cards as face-down and unmatched
        game.restart()
        self.view.backgroundColor = theme.backgroundColor
        cardColor = theme.cardColor
        updateViewFromModel()
    }
    
    private var cardColor = #colorLiteral(red: 1, green: 0.3929034536, blue: 0.08472232499, alpha: 1)
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 0.803833425, green: 0.8039723635, blue: 0.8038246036, alpha: 1)
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
            } else {
                button.backgroundColor = card.isMatched ? self.view.backgroundColor : cardColor
                button.setTitle("", for: UIControl.State.normal)
            }
            flipCountLabel.text = "Flips: \(game.flipCount)"
            score.text = "Score: \(game.score)"
        }
    }
    
    private lazy var emojiChoices = emojiThemes[emojiThemes.count.arc4random]
    
    // association of button IDs and emojis
    private var emoji = [Card:String]()
    
    private func emoji(for card:Card) -> String {
        // there is no emoji associated with this card and there are emojis still available
        if emoji[card] == nil, emojiChoices.count>0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self != 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}

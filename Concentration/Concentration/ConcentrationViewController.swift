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
        let theme = colorSchemes[colorSchemes.count.arc4random]
        // reset the association between cards and emojis
        emoji = [Card:Int]()
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
              let emojiIndex = emoji(for: card)
              var emoji = "?"
              if emojiChoices.indices.contains(emojiIndex) {
                emoji = emojiChoices[emojiIndex]
              }
              button.setTitle(emoji, for: UIControl.State.normal)
            } else {
                button.backgroundColor = card.isMatched ? self.view.backgroundColor : cardColor
                button.setTitle("", for: UIControl.State.normal)
            }
            flipCountLabel.text = "Flips: \(game.flipCount)"
            score.text = "Score: \(game.score)"
        }
    }
    
  public var emojiChoices: [String] = [] {
    willSet(newValue) {
      availableEmojiIndices = Array(newValue.indices)
      emoji = [Card:Int]()
    }
    didSet {
      if cardButtons != nil {
        updateViewFromModel()
      }
    }
  }
  
  private var availableEmojiIndices: [Int] = []
  
    // association of button IDs and emojis
    private var emoji = [Card:Int]()
    
    private func emoji(for card:Card) -> Int {
        // there is no emoji associated with this card and there are emojis still available
        if emoji[card] == nil, availableEmojiIndices.count>0 {
          let randomIndex = availableEmojiIndices.count.arc4random
          emoji[card] = availableEmojiIndices[randomIndex]
          availableEmojiIndices.remove(at: randomIndex)
        }
        
        return emoji[card] ?? -1
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


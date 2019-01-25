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
    private var moreCardsCanBeShown: Bool {
        get {
            return game.cardsPlaying.count < 24
        }
    }
    private var shapes = ["▲","●","■"]
    private var fill = [-5, 5, 0.25]
    private var colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    
    @IBOutlet var cards: [UIButton]!
    
    @IBAction func selectCard(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Set()
        for _ in 0..<4 {
            game.dealThreeCards()
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in game.cardsPlaying.indices {
            let card = game.cardsPlaying[index]
            let attributes: [NSAttributedString.Key:Any]
            if card.shading.rawValue<3 {
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
            cards[index].setAttributedTitle(attributedString, for: UIControl.State.normal)
        }
    }
}

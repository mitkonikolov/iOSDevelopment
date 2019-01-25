//
//  Set.swift
//  Set
//
//  Created by Mitko Nikolov on 1/21/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import Foundation

class Set {
    lazy var deck: [Card] = createDeck()
    
    private(set) var cardsPlaying: [Card] = []
    var selectedCards: [Card] = []
    
    /// Generates all cards for the deck and returns them as an array.
    private func createDeck() -> [Card] {
        var cards: [Card] = []
        for n in Property.allCases {
            for c in Property.allCases {
                for sl in Property.allCases {
                    for shg in Property.allCases {
                        cards.append(Card(number: n, color: c, symbol: sl, shading: shg))
                    }
                }
            }
        }
        return cards.shuffled()
    }
    
    func dealThreeCards() -> Bool {
        if deck.count<3 {
            return false
        }
        var index = 0
        for _ in 0..<3 {
            index = deck.count.arc4random
            let card = deck.remove(at: index)
            cardsPlaying.append(card)
        }
        return true
    }
}

extension Int {
    var arc4random: Int {
        if self != 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        }
        return 0
    }
}


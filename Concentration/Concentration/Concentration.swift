//
//  Concentration.swift
//  Concentration
//
//  Created by Mitko Nikolov on 12/31/17.
//  Copyright © 2017 Mitko Nikolov. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    }
                    else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0

    var score:Int = 0
    
    private var lastTouch: Date?
    
    func chooseCard(at index:Int) {
        assert(cards.indices.contains(index), "Concentation.chooseCard(at: \(index): chosen index not in cards")
        var moveSpeed = 0.0
        if lastTouch != nil {
            moveSpeed = abs(lastTouch!.timeIntervalSinceNow)
        }
        lastTouch = Date.init()
        if !cards[index].isMatched, !cards[index].isFaceUp {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                cards[index].isFaceUp = true
                if cards[index].isMatched {
                    if moveSpeed <= 0.8 {
                        score += 4
                    }
                    else if moveSpeed <= 1.5 {
                        score += 3
                    }
                    else {
                        score += 2
                    }
                }
                else if cards[index].isSeen {
                    if moveSpeed > 4 {
                        score -= 2
                    }
                    else {
                        score -= 1
                    }
                }
                cards[index].isSeen = true
            }
                // 0 or 2 cards are face up
            else {
                indexOfOneAndOnlyFaceUpCard = index
                if cards[index].isSeen {
                    if moveSpeed > 4 {
                        score -= 2
                    }
                    else {
                        score -= 1
                    }
                }
                cards[index].isSeen = true
            }
            flipCount += 1
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): at least one pair of cards is required")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    func restart() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isSeen = false
        }
        indexOfOneAndOnlyFaceUpCard = nil
        flipCount = 0
        score = 0
        lastTouch = nil
    }
}

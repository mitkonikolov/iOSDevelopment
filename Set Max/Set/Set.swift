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

  var randomCard: Card? {
    let index = deck.count.arc4random
    return deck.count >= 1 ? deck.remove(at: index) : nil
  }
  var score = 0
  private(set) var cardsPlaying: [Card] = []
  var selectedCardsIndices: [Int] = []

  var selectedCardsFormAMatch: Bool {
    if selectedCardsIndices.count < 3 {
      return false
    }
    let card0 = cardsPlaying[selectedCardsIndices[0]]
    let card1 = cardsPlaying[selectedCardsIndices[1]]
    let card2 = cardsPlaying[selectedCardsIndices[2]]

    if ((card0.number == card1.number) && (card0.number == card2.number)) || (
      (card0.number != card1.number) && (card0.number != card2.number) && (
        card1.number != card2.number
      )
    ) {
      if ((card0.color == card1.color) && (card0.color == card2.color)) || (
        (card0.color != card1.color) && (card0.color != card2.color) && (
          card1.color != card2.color
        )
      ) {
        if ((card0.shading == card1.shading) && (card0.shading == card2.shading)
        ) || (
          (card0.shading != card1.shading) && (card0.shading != card2.shading)
            && (card1.shading != card2.shading)
        ) {
          if ((card0.symbol == card1.symbol) && (card0.symbol == card2.symbol))
            || (
            (card0.symbol != card1.symbol) && (card0.symbol != card2.symbol)
              && (card1.symbol != card2.symbol)
          ) {
            return true
          }
        }
      }
    }
    return false
  }

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

  func dealThreeCards() {
    if !deck.isEmpty {
      for _ in 0..<3 {
        cardsPlaying.append(randomCard!)
      }
    }
  }

  func selectCard(at index: Int) {
    assert(
      cardsPlaying.indices.contains(index),
      "Set.selectCard(at: \(index): chosen index not in cardsPlaying"
    )
    if selectedCardsIndices.count == 3 {
      selectedCardsIndices = []
    }
    selectedCardsIndices.append(index)
    if selectedCardsIndices.count == 3 {
      if selectedCardsFormAMatch {
        score += 3
      } else {
        score -= 5
      }
    }
  }

  func replaceMatchedPlayingCardsWithRandomOnes() {
    if deck.isEmpty {
      cardsPlaying = cardsPlaying.filter {
        for index in selectedCardsIndices {
          if $0 == cardsPlaying[index] {
            return false
          }
        }
        return true
      }
    } else {
      for index in selectedCardsIndices {
        cardsPlaying.remove(at: index)
        cardsPlaying.insert(randomCard!, at: index)
      }
    }
    selectedCardsIndices = []
  }

  func deselectCard(number cardNumber: Int) {
    selectedCardsIndices = selectedCardsIndices.filter { $0 != cardNumber }
    score -= 1
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

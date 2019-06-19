//
//  Card.swift
//  Set
//
//  Created by Mitko Nikolov on 1/21/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import Foundation

struct Card: Equatable, Hashable {
  let number: Property
  let color: Property
  let symbol: Property
  let shading: Property

  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.number == rhs.number && lhs.color == rhs.color && lhs.symbol
      == rhs.symbol && lhs.shading == rhs.shading
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(number)
    hasher.combine(color)
    hasher.combine(symbol)
    hasher.combine(shading)
  }

  var hashValue: Int {
    return number.rawValue + (color.rawValue * 3) + (symbol.rawValue * 5) + (
      shading.rawValue * 7
    )
  }

}

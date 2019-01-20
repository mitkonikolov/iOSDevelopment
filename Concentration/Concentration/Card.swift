//
//  Card.swift
//  Concentration
//
//  Created by Mitko Nikolov on 12/23/18.
//  Copyright © 2018 Mitko Nikolov. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier: Int
    var isFaceUp = false
    var isMatched = false
    var isSeen = false

    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
}

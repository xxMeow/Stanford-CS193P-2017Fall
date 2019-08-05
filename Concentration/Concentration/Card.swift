//
//  Card.swift
//  Concentration
//
//  Created by XMX on 2019/08/1.
//  Copyright © 2019 XMX. All rights reserved.
//

import Foundation

struct Card: Hashable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.identifier == rhs.identifier)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int { // Obtain the unique increasing identifier for card
        identifierFactory += 1
        return identifierFactory
    }
    
    init () {
        // Each card is initialized with FaceDown, Unmatched and unique identifier
        self.identifier = Card.getUniqueIdentifier()
    }
}

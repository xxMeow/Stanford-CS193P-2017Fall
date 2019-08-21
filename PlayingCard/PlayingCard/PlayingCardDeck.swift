//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by XMX on 2019/08/8.
//  Copyright © 2019 XMX. All rights reserved.
//

import Foundation

/**
 * A whole deck of cards stored in an array.
 * Providing the method draw() which return a card in the deck randomly when the deck is not empty.
 */
struct PlayingCardDeck {
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

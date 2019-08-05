//
//  Concentration.swift
//  Concentration
//
//  Created by XMX on 2019/08/1.
//  Copyright © 2019 XMX. All rights reserved.
//

import Foundation

struct Concentration {
    private(set) var cards = [Card]() // Initializing an empty Card array
    
    private var leftPairsCount = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { // Get the indexOfOneAndOnlyFaceUpCard by looking up all the cards on the board
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else { // If foundIndex has been set before this iteration (2 cards are facing up at this time)
//                        foundIndex = nil
//                    }
//                }
//            }
//            
//            return foundIndex
        }
        
        set { // The right value will be seemd as newValue by default
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    mutating func chooseCard(at index: Int) -> Int{ // Choose a card (chosen by accepting its index in cards array)
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards.")
        
        if !cards[index].isMatched { // It can be chosen only when it's not matched yet
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index { // If there's ANOTHER card facing up
                // Flip card
                cards[index].isFaceUp = true
                // Check if two cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    leftPairsCount -= 1
                    if leftPairsCount == 0 {
                        return 1 // Matched the last pair of cards successfully! -> score += 5 and Game Over!
                    }
                    
                    return 0 // Matched Successfully! -> score += 5
                }
            } else { // Either no cards or two cards are facing up, then make it the oneAndOnlyFaceUpCard
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        
        return -1 // Nothing happened
    }
    
    init (numberOfPairsOfCards: Int) { // Add 2 same cards once time as each pair
        assert(numberOfPairsOfCards > 0, "Concentartion.init(\(numberOfPairsOfCards): you must have at least 1 pair of cards.")
        leftPairsCount = numberOfPairsOfCards
        
        for _ in 0..<numberOfPairsOfCards {
            let card = Card() // Initialize a card
            cards += [card, card]
        }
        
        // TODO: shuffle the cards
        for _ in 0..<((numberOfPairsOfCards - 1) * 2) { // Swap two cards' identifier fot some times
            let randomCardA = Int(arc4random_uniform(UInt32(cards.count)))
            let randomCardB = Int(arc4random_uniform(UInt32(cards.count)))
            
            // Swap
            let tempIdentifier = cards[randomCardA]
            cards[randomCardA] = cards[randomCardB]
            cards[randomCardB] = tempIdentifier
        }
        
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

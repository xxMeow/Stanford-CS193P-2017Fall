//
//  ViewController.swift
//  PlayingCard
//
//  Created by XMX on 2019/08/7.
//  Copyright © 2019 XMX. All rights reserved.
//

import UIKit

/**
 * Connected to a rectangle outlet on the screen.
 * Generate a deck of cards and draw one of them in the rectangle.
 * Provide swipe(show next in the deck), pinch(zoom in/out) and tap(flip) gestures for the drawn card.
 */
class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    /** Initialize animator */
    lazy var animator = UIDynamicAnimator(referenceView: view)
    /** Initialize behaviors */
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an empty array of elements of type PlayingCard
        var cards = [PlayingCard]()
        // Fill the array with random card pairs, each pair of them have the same suit and rank
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.suit = card.suit.rawValue
            cardView.rank = card.rank.order
            
            // Add gesture recognizer
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            
            /** Add behaviors to card */
            cardBehavior.addItem(cardView)
        }
    }
    
    // Track cards which are facing up right now
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0) && $0.alpha == 1}
    }
    // Check if the 2 facing up cards match
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                
                // Stop all the behaviors of the chosen card
                cardBehavior.removeItem(chosenCardView)
                
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromBottom],
                    animations: {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    },
                    // After this animation, check the number of facing up cards
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch { // If there're 2 cards facing up and matching
                            // Match them
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
                                    }
                                },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardsToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                                            }
                                        }
                                    )
                                }
                            )
                            
                        } else if cardsToAnimate.count == 2 { // If there're 2 cards facing up but not matching
                            if chosenCardView == self.lastChosenCardView {
                                // Flip them over
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.6,
                                        options: [.transitionFlipFromTop],
                                        animations: {
                                            cardView.isFaceUp = false
                                        },
                                        completion: { finished in
                                            self.cardBehavior.addItem(cardView )
                                        }
                                    )
                                }
                            }
                        } else {
                            if !chosenCardView.isFaceUp { // If user picked the card that has been face up
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                    }
                )
                
            }
        default:
            break
        }
    }

}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat.random(in: 0...self)
        } else if self < 0 {
            return -CGFloat.random(in: 0...abs(self))
        } else {
            return 0
        }
    }
}

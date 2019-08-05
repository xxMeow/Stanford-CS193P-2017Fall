//
//  ViewController.swift
//  Concentration
//
//  Created by XMX on 2019/08/1.
//  Copyright © 2019 XMX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    // In case of the number of cards being odd
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var scoreRecord = 0 {
        didSet {
            scoreRecordLabel.text = "Score: \(scoreRecord)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreRecordLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) { // If a cardButton is touched
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            if !game.cards[cardNumber].isMatched, !game.cards[cardNumber].isFaceUp {
                flipCount += 1 // Count 1
                scoreRecord -= 1
                
                let resultOfChoosing = game.chooseCard(at: cardNumber)
                if resultOfChoosing >= 0 { // Matched successfully
                    scoreRecord += 6
                }
                
                updateViewFromModel()
                
                if resultOfChoosing == 1 { // Game Over: All the cards are matched
                    gameOver = true
                }
            }
        } else { // Execpt Catch
            print("Chosen card was not in cardButtons!")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices { // Traversal all the cardButtons
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp { // Show the front
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else { // Show the back (if the card is still on the board)
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 0.3226475716, green: 0.1143690571, blue: 0.4838612676, alpha: 1)
            }
        }
    }
    
    var gameOver = false {
        didSet {
            if gameOver {
                gameOverLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                gameOverLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                gameOverLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0)
                gameOverLabel.textColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0)
            }
        }
    }
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    var emojiChoices = ["🔮", "🎃", "👻", "🕷", "🕸", "⚰️", "🌙", "⚡️"]
    
    var emoji = [Card:String]()
    func emoji(for card: Card) -> String {
        // If the card has no emoji, and there are usable emoji in the emojiChoices left
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card] ?? "!"
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



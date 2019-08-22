//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by XMX on 2019/08/22.
//  Copyright © 2019 XMX. All rights reserved.
//

import UIKit

/**
 * Collection of behaviors that a card can perform.
 * A new behavior:
 *  - Initialize a behavior var
 *  - Set it's properties
 *  - Add it to the animator
 */
class CardBehavior: UIDynamicBehavior
{
    /** Behaviors of Card */
    // Collisions betwwen cards and boundaries
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior // Return from closure
    }()
    // Collisions among cards
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0 // Moving without accelerating situation
        behavior.resistance = 0
        return behavior
    }()
    
    // Push Card
    private func push(_ item: UIDynamicItem) { // Arg: $item gets pushed
        let push = UIPushBehavior(items: [item], mode: .instantaneous) // Arg: $items will be pushed in $mode
        // Since it is instantaneous push, we're gonna wanna clean up after it later
        
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            // Always push the card towards center
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi - (CGFloat.pi/2).arc4random
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi + (CGFloat.pi/2).arc4random
            default:
                push.angle = (CGFloat.pi*2).arc4random
            }
        }
        push.magnitude = CGFloat(1.0) + CGFloat (2.0).arc4random // Set megnitude between 1.0~3.0
        // Remove push as soon as it happend
        push.action = { [unowned push, weak self] in // Use unowned to avoid the memory cycle
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }

    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        // Push will remove itself as soon as it happend
    }
    
    override init() { // Now this init() will do the job that add each behavior to the item(animator)
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

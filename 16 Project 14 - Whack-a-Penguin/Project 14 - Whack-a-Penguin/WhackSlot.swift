//
//  WhackSlot.swift
//  project14_penguin
//
//  Created by Berserk on 24/10/2023.
//

import SpriteKit

class WhackSlot: SKNode {
    
    // MARK: - Properties
    
    var charNode: SKSpriteNode!
    var isVisible: Bool = false
    var isHit: Bool = false
    
    // MARK: - Methods
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0.0, y: 15.0)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0.0, y: -90.0)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        
        guard !isVisible else { return }
        
        charNode.xScale = 1.0
        charNode.yScale = 1.0
        charNode.run(SKAction.moveBy(x: 0.0, y: 80.0, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        
        guard isVisible else { return }
        
        charNode.run(SKAction.moveBy(x: 0.0, y: -80.0, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0.0, y: -80.0, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        }
        
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
}

//
//  GameScene.swift
//  Project11-pachenko
//
//  Created by Berserk on 09/10/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64.0, height: 64.0))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64.0, height: 64.0))
            box.position = location
            addChild(box)
        }
    }
}

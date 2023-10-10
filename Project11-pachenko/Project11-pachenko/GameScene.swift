//
//  GameScene.swift
//  Project11-pachenko
//
//  Created by Berserk on 09/10/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var scoreLabel: SKLabelNode!
    private var editLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeBouncer(at: CGPoint(x: 0.0, y: 0.0))
        makeBouncer(at: CGPoint(x: 256, y: 0.0))
        makeBouncer(at: CGPoint(x: 512, y: 0.0))
        makeBouncer(at: CGPoint(x: 768, y: 0.0))
        makeBouncer(at: CGPoint(x: 1024, y: 0.0))
        
        makeSlot(at: CGPoint(x: 128.0, y: 0.0), isGood: true)
        makeSlot(at: CGPoint(x: 384.0, y: 0.0), isGood: false)
        makeSlot(at: CGPoint(x: 640.0, y: 0.0), isGood: true)
        makeSlot(at: CGPoint(x: 896.0, y: 0.0), isGood: false)
        
        setupScoreLabel()
        setupEditLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0), size: size)
                    box.position = location
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    addChild(box)
                } else {
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position = CGPoint(x: location.x, y: 650.0)
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: nodeA)
        }
    }
    
    private func setupScoreLabel() {
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980.0, y: 700.0)
        addChild(scoreLabel)
    }
    
    private func setupEditLabel() {
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80.0, y: 700.0)
        addChild(editLabel)
    }
    
    private func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    private func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    private func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    private func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
}

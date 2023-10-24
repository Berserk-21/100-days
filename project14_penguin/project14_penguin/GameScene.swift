//
//  GameScene.swift
//  project14_penguin
//
//  Created by Berserk on 24/10/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    var slots: [WhackSlot] = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var numRounds = 0
    
    var popupTime: CGFloat = 0.85
    
    // MARK: - Content
    
    override func didMove(to view: SKView) {
        
        let bounds = UIScreen.main.bounds

        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: bounds.midX, y: bounds.midY)
        background.blendMode = .replace
        background.size = CGSize(width: bounds.maxX, height: bounds.maxY)
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: \(score)"
        gameScore.position = CGPoint(x: 8.0, y: 8.0)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48.0
        addChild(gameScore)
        
        for i in 0 ..< 5 {
            createSlot(at: CGPoint(x: 100.0 + (CGFloat(i) * 170.0), y: 410.0))
        }
        
        for i in 0 ..< 4 {
            createSlot(at: CGPoint(x: 180.0 + (CGFloat(i) * 170), y: 320.0))
        }
        
        for i in 0 ..< 5 {
            createSlot(at: CGPoint(x: 100.0 + (CGFloat(i) * 170), y: 230.0))
        }
        
        for i in 0 ..< 4 {
            createSlot(at: CGPoint(x: 180.0 + (CGFloat(i) * 170.0), y: 140.0))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    // MARK: - Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            
            guard let whackSlot = node.parent?.parent as? WhackSlot else { return }
            guard whackSlot.isVisible, !whackSlot.isHit else { return }
            
            if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))

            } else if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }
            
            whackSlot.hit()
        }
    }
    
    // MARK: - Methods
    
    private func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    private func createEnemy() {
        
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            return
        }
        
        popupTime *= 0.991
        slots.shuffle()
        slots.first?.show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
        }
        
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popupTime)
        }
        
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popupTime)
        }
        
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popupTime)
        }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        
        let randomWait = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomWait) { [weak self] in
            self?.createEnemy()
        }
    }
}

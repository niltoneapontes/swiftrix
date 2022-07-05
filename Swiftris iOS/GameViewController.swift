//
//  GameViewController.swift
//  Swiftris iOS
//
//  Created by Nilton Pontes on 04/07/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene!
    var swiftris:Swiftris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.backgroundColor = UIColor.blue
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick

        swiftris = Swiftris()
        swiftris.beginGame()

        
        // Present the scene
        skView.presentScene(scene)
        
        scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
            self.swiftris.nextShape?.moveTo(column: StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(shape: self.swiftris.nextShape!) {
                let nextShapes = self.swiftris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(shape: nextShapes.nextShape!) {}
            }
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func didTick() {
        swiftris.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(shape: swiftris.fallingShape!, completion: {})
    }
}

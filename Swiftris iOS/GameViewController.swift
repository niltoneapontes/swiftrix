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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.backgroundColor = UIColor.blue
        scene.scaleMode = .aspectFill
        
        // Present the scene
        skView.presentScene(scene)
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//
//  GameViewController.swift
//  Swiftris iOS
//
//  Created by Nilton Pontes on 04/07/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {


    var scene: GameScene!
    var swiftris:Swiftris!
    var panPointReference:CGPoint?
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.backgroundColor = UIColor.blue
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick

        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()

        
        // Present the scene
        skView.presentScene(scene)
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.y - originalPoint.y) > 100 {
                swiftris.dropShape()
            }
            else if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {

                if sender.velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        print("Swiped")
    }
    
    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    func nextShape() {
             let newShapes = swiftris.newShape()
             guard let fallingShape = newShapes.fallingShape else {
                 return
             }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
    // #16
                 self.view.isUserInteractionEnabled = true
                 self.scene.startTicking()
             }
         }

         func gameDidBegin(swiftris: Swiftris) {
             // The following is false when restarting a new game
             if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
                 scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                     self.nextShape()
                 }
             } else {
                 nextShape()
             }
         }

         func gameDidEnd(swiftris: Swiftris) {
             view.isUserInteractionEnabled = false
             scene.stopTicking()
         }

         func gameDidLevelUp(swiftris: Swiftris) {
     
         }

         func gameShapeDidDrop(swiftris: Swiftris) {
             scene.stopTicking()
             scene.redrawShape(shape: swiftris.fallingShape!) {
                 swiftris.letShapeFall()
             }
         }

         func gameShapeDidLand(swiftris: Swiftris) {
             scene.stopTicking()
             nextShape()
         }

    // #17
         func gameShapeDidMove(swiftris: Swiftris) {
             scene.redrawShape(shape: swiftris.fallingShape!) {}
         }
}

//
//  GameViewController.swift
//  BatGame
//
//  Created by Sukum Duangpattra on 29/5/2562 BE.
//  Copyright © 2562 Sukum Duangpattra. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView

        skView.showsFPS                 = true
        skView.showsNodeCount           = true
        skView.ignoresSiblingOrder      = true
        scene.scaleMode                 = .resizeFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

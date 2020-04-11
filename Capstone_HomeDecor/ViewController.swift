//
//  ViewController.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-11.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
    }
}

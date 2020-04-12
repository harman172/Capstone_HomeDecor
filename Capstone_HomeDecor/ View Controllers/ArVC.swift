//
//  ViewController.swift
//  Group P Capstone
//
//  Created by Abhinav Bhardwaj on 2020-04-08.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit
import ARKit

class ArVC: UIViewController {
    
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var nodeName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
              self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
       
        let node = SCNScene(named: "art.scnassets/\(nodeName!).scn")
        let childNode1 = node?.rootNode.childNode(withName: "\(nodeName!)", recursively: true)
        childNode1?.position = SCNVector3(-0.5,-1,-2)
        self.sceneView.scene.rootNode.addChildNode(childNode1!)
        
       
    }
    
    
    @IBAction func captureButtonPressed(_ sender: UIButton) {
        
//        let destVC = storyboard?.instantiateViewController(identifier: "testVC") as! TestVC
//
//        destVC.capturedImage = captureImage()
//        navigationController?.pushViewController(destVC, animated: true)
//
    }
    
    func captureImage()->UIImage{
        
       let capturedImage = self.sceneView.snapshot()
        
        return capturedImage
    }
    
    
    
    
}


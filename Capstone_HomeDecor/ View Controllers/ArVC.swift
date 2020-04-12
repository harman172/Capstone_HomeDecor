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
        
        let capturedImage = self.sceneView.snapshot()
       
       let saved = saveImage(image: capturedImage)
        
        if saved{
           print("successful")
        }
        else{
            print("error")
        }
        
    
    }
    

    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        
        }
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let dirContents = try? fileManager.contentsOfDirectory(atPath: documentsPath)
        let count = dirContents?.count
        
        print(count as Any)
        do {
            let stringPath = directory.appendingPathComponent("\(count ?? 0).png")!
                try  data.write(to: stringPath )
                print("----actual path---")
                print(stringPath)
            
           
            
            
            
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
}


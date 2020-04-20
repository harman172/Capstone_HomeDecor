//
//  ViewController.swift
//  Group P Capstone
//
//  Created by Abhinav Bhardwaj on 2020-04-08.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import FirebaseAuth


class ArVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var zUpBtn: UIButton!
    @IBOutlet weak var zDownBtn: UIButton!
    @IBOutlet weak var scaleTF: UITextField!
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    
    var CurrentNode: SCNNode!
    var nodeToAdd : String!
    var objUrl:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
        // tap gesture
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
        let gesture4 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
        let gesture5 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
        let gesture6 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
         let gesture7 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture: )))
        
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        gesture4.minimumPressDuration = 0.1
        gesture5.minimumPressDuration = 0.1
        gesture6.minimumPressDuration = 0.1
        gesture7.minimumPressDuration = 0.1
        
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
        leftBtn.addGestureRecognizer(gesture4)
        rightBtn.addGestureRecognizer(gesture5)
        zUpBtn.addGestureRecognizer(gesture6)
        zDownBtn.addGestureRecognizer(gesture7)
        
        
        
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CustomerHomeVC.multipleObjMode = false
        print("view will appear called")
        
            addNewItem(nodeName: nodeToAdd)
    
        
        
    }
    
    func addNewItem(nodeName: String){
      //  let node = SCNScene(named: "art.scnassets/\(nodeName).scn")
        do {
            
            let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
            
            var file_name = 0
        
                                   
                               
                                                             
            let furl = (directory?.appendingPathComponent("\(file_name).scn"))!
            
            
            
           let node = try SCNScene(url: furl, options: nil)
            let name = node.rootNode.childNodes.last?.name
             print(name!)
             print(node.rootNode.childNodes.count)
            
            CurrentNode = node.rootNode.childNode(withName: "tryObject", recursively: true)
             CurrentNode?.position = SCNVector3(-0.5,-1,-2)
             self.sceneView.scene.rootNode.addChildNode(CurrentNode!)
        } catch  {
            print(error.localizedDescription)
        }
        
        
//        let a = SCNScene(url: <#T##URL#>, options: [SCNSceneSource.LoadingOption : Any]?)
        
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
        guard let data =  image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        
        }
        let fileManager = FileManager.default
        
    do {let newdir = directory.appendingPathComponent("\(CustomerHomeVC.username!)")
    
    do {
        try fileManager.createDirectory(atPath: newdir!.path, withIntermediateDirectories: true, attributes: nil)
    }   catch let error as NSError
              {
                  print("Unable to create directory \(error.debugDescription)")
              }
        
        
        
        
       // let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let dirContents = try? fileManager.contentsOfDirectory(atPath: newdir!.path)
        let count = dirContents?.count
        
        print(count as Any)
        
        
    
       
        
        
            let stringPath = newdir!.appendingPathComponent("\(count ?? 0).png")
            print(stringPath)
                try  data.write(to: stringPath )
                print("----actual path---")
                print(stringPath)
            
            
            return true
        } catch {
            print("--------ERROR----------")
            print(error.localizedDescription)
            return false
        }
    }
    
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer){
        
        if let ObjNodeEdit = CurrentNode{
            
            if gesture.state == .ended {
                ObjNodeEdit.removeAllActions()
            }else if gesture.state == .began{
                if gesture.view === rotateBtn{
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ObjNodeEdit.runAction(rotate)
                    
                }else if gesture.view === upBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ObjNodeEdit.runAction(move)
                }else if gesture.view === downBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ObjNodeEdit.runAction(move)
                }else if gesture.view === leftBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: -0.08, y: 0, z: 0, duration: 0.1))
                    ObjNodeEdit.runAction(move)
                }else if gesture.view === rightBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0.08, y: 0, z: 0, duration: 0.1))
                    ObjNodeEdit.runAction(move)
                }
                else if gesture.view === zUpBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: -0.08, duration: 0.1))
                    ObjNodeEdit.runAction(move)
                }
                else if gesture.view === zDownBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: 0.08, duration: 0.1))
                    ObjNodeEdit.runAction(move)
                }
                
                
            }
        }
        
        
    }
    
    
    
    @IBAction func scalePressed(_ sender: UIButton) {
        
        var scaleFactor = Float(scaleTF.text!) ?? 1.0
        CurrentNode?.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor)
        scaleTF.resignFirstResponder()
    }
    
    @IBAction func addNewObj(_ sender: UIButton) {
        
        let homeVC = storyboard?.instantiateViewController(identifier: "CustomerVC") as! CustomerHomeVC
        homeVC.del_ARVC = self
        CustomerHomeVC.multipleObjMode = true
        navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    
    
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        
        
        let homeVC = storyboard?.instantiateViewController(identifier: "ObjVC") as! ObjectBrowserViewController
               homeVC.Delegate_ArVC = self
               
               navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let dest = segue.destination as? ObjectBrowserViewController2{
//            
//        }
//    }
    
    
    
    
}


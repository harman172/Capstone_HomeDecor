//
//  DocumentBrowserViewController.swift
//  file1234
//
//  Created by Parth Dalwadi on 2020-04-12.
//  Copyright © 2020 Parth Dalwadi. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ObjectBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var Delegate_AddObj: AddNewItemViewController?
    var Delegate_ArVC: ArVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = nil
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        //presentDocument(at: sourceURL)
        
        if let d = Delegate_AddObj{
            
            print("inside add obj")
            print(sourceURL)
            Delegate_AddObj?.objDoc = UIDocument(fileURL: sourceURL)
            Delegate_AddObj?.objPathL.text = sourceURL.lastPathComponent
            
            do {
                let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
                     
                    let furl = directory?.appendingPathComponent("\(0).scn")
                                       
                    print(furl)
                                 let node = try SCNScene(url: furl! , options: nil)
                                  print(node.rootNode.name)
                                  let name = node.rootNode.childNodes.last?.name
                                   print(name)
                                   print(node.rootNode.childNodes.count)
                                  
                              } catch  {
                                  print(error.localizedDescription)
                              }
        }
        
        print(sourceURL)
       
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        //presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    
}


//
//  ImageVC.swift
//  Capstone_HomeDecor
//
//  Created by Abhinav Bhardwaj on 2020-04-13.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var imgPath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = UIImage(contentsOfFile: imgPath!)
        
    }
    

    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
       
       let alert = UIAlertController(title: "Delete Image", message: "Are you sure", preferredStyle: .alert)
       
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
           let filePath = FileManager.default
                         
                         do {
                           try filePath.removeItem(atPath: self.imgPath!)
    
                            self.navigationController?.popViewController(animated: true)
                         } catch  {
                            self.alert(title: "Error", message: "Unable to delete Image", actionTitle: "Cancel")
                         }
       }))
       
       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
       self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func alert(title: String , message: String , actionTitle: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}

//
//  AddNewItemViewController.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-14.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Kingfisher


class AddNewItemViewController: UIViewController {

    var imgDoc: UIDocument?
    var objDoc: UIDocument?
    
    
    @IBOutlet weak var objPathL: UILabel!
    
    @IBOutlet weak var titleL: UITextField!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var objDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let imgD = imgDoc{
            setImage(doc: imgD)
        }
        
        
    }
    
    
    
    func setImage(doc : UIDocument){
            self.imageV.image = UIImage(contentsOfFile: (doc.presentedItemURL!.path))
    }

    @IBAction func btnUploadTapped(_ sender: UIButton) {
        uploadImageToFirebaseStorage()
    }
    
    func uploadImageToFirebaseStorage(){
        guard let image = imageV.image, let data = image.jpegData(compressionQuality: 1.0) else {
            print("Something went wrong!!")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference()
            .child("Uploaded Images").child(uid).child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            if let error = error{
                print("error....\(error.localizedDescription)")
                return
            }
            
            print("Image uploaded successfully!!!")
        }
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let dest = segue.destination as? ObjectBrowserViewController{
            
            dest.Delegate_AddObj = self
            
        }
        if let dest = segue.destination as? ImageBrowserViewController{
            
            dest.Delegate_AddObj = self
            
        }
        
        
        
    }
    

}

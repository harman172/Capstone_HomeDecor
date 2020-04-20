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
import FirebaseFirestore


class AddNewItemViewController: UIViewController {

    var imgDoc: UIDocument?
    var objDoc: UIDocument?
    
    
    @IBOutlet weak var objPathL: UILabel!
    
    @IBOutlet weak var titleL: UITextField!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var objDescription: UITextView!
    
    var fileName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        print("view did load")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let imgD = imgDoc{
            setImage(doc: imgD)
        }
        fileName = Constants.FILENAME
        print("will appear")
        
    }
    func setImage(doc : UIDocument){
            self.imageV.image = UIImage(contentsOfFile: (doc.presentedItemURL!.path))
    }

    @IBAction func btnUploadTapped(_ sender: UIButton) {
        uploadImageToFirebaseStorage()
        print(objDoc!.presentedItemURL)
        uploadFileToFirebaseStorage(u: objDoc!.fileURL)
    }
    
    func uploadImageToFirebaseStorage(){
        guard let image = imageV.image, let data = image.jpegData(compressionQuality: 1.0) else {
            print("Something went wrong!!")
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let imageReference = Storage.storage().reference()
            .child("Uploaded Images").child(uid).child(fileName)
        
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            if let error = error{
                print("error....\(error.localizedDescription)")
                return
            }
            
            print("Image uploaded successfully!!!")
        }
        
        
    }
    func uploadFileToFirebaseStorage(u: URL){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
//        let fileName = UUID().uuidString
        let fileReference = Storage.storage().reference()
            .child("Uploaded Files").child(uid).child(fileName)
        
        fileReference.putFile(from: u, metadata: nil) { (metadata, error) in
            if let error = error{
                print("error....\(error.localizedDescription)")
                return
            }
            
            /*
            fileReference.downloadURL { (url, err) in
                if let error = error{
                    print("error....\(error.localizedDescription)")
                    return
                }
                
                guard let url = url else{
                    print("Error...Something went wrong")
                    return
                }
                let urlString = url.absoluteString
                
                //document id for data reference
                let dataReference = Firestore.firestore().collection("business").document(uid)
                
                let data = [
                    "doc": urlString
                ]
                
                dataReference.setData(data, merge: true) { (err) in
                    if let err = err{
                        print("error data....\(err.localizedDescription)")
                        return
                    }
                    print("Success storing document")
                }
            
            }
 */
            print("Document uploaded successfully!!!")
            
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

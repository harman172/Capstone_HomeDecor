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
import Firebase


class AddNewItemViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var objPathL: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    
    var fileName = ""
    var imgDoc: UIDocument?
    var objDoc: UIDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDescription.delegate = self
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        self.view.addGestureRecognizer(gesture)
        
    }
    @objc func userTapped(){
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let imgD = imgDoc{
            setImage(doc: imgD)
        }
        fileName = Constants.FILENAME
    }
    
    func setImage(doc : UIDocument){
        self.imageV.image = UIImage(contentsOfFile: (doc.presentedItemURL!.path))
    }
    
    func validations() -> Bool{
        if (txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return false
        }
        return true
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func btnUploadTapped(_ sender: UIButton) {
        
        guard validations() else {
            showAlert(message: "All fields are required!")
            return
        }
        
        uploadImageToFirebaseStorage()
        print(objDoc!.presentedItemURL)
        uploadFileToFirebaseStorage(u: objDoc!.fileURL)
        
        let title = txtTitle.text!
        let description = txtDescription.text!
        
        let db = Firestore.firestore()
        db.collection("uploaded data").document(fileName).setData(["title" : title, "description" : description]) { (error) in
            if error != nil{
                print("Error writing document")
            }
            self.showAlert(message: "Item uploaded successfully!!")
        }
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
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtDescription.text = ""
        
    }
    
    
    
    
}

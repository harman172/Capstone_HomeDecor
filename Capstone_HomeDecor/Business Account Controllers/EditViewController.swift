//
//  EditViewController.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-21.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class EditViewController: UIViewController {
    
    var id: String?
    var itemTitle:String?
    var itemDescription:String?
    var del_Home: BusinessHomeVC?
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Edit item"
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        let db = Firestore.firestore()
        let collection = db.collection("uploaded data").document(id!)
        collection.getDocument { (document, error) in
            if let document = document, document.exists {
                self.txtTitle.text = document.data()!["title"] as! String
                self.txtDescription.text = document.data()!["description"] as! String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func userTapped(){
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        txtDescription.resignFirstResponder()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("uploaded data").document(id!).setData(["title" : txtTitle.text!, "description" : txtDescription.text!]) { (err) in
            if let err = err{
                print("error while updating\(err.localizedDescription)")
                return
            }
            self.showAlert(message: "Item updated successfully!!")
        }
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        //delete images from storage
        let imageRef = Storage.storage().reference().child("Uploaded Images").child(Constants.ID)
            .child(id!)
        imageRef.delete { (err) in
            if let err = err{
                print("error while deleting\(err.localizedDescription)")
                return
            }
            print("image deleted")
        }
        
        //delete files from storage
        let filesRef = Storage.storage().reference().child("Uploaded Files").child(Constants.ID)
            .child(id!)
        filesRef.delete { (err) in
            if let err = err{
                print("error while deleting\(err.localizedDescription)")
                return
            }
            print("file deleted")
            self.showAlert(message: "Item deleted successfully!!")
        }
        
        //delete from database
        let db = Firestore.firestore()
        db.collection("uploaded data").document(id!).delete { (err) in
            if let err = err{
                print("error while deleting\(err.localizedDescription)")
                return
            }
            print("database deleted")
            
            
        }
        
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.del_Home?.loadImages()
            print("load images called in alert")
            self.navigationController?.popViewController(animated: true)
            
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}

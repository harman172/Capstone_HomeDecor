//
//  ObjectDescVC.swift
//  Group P Capstone
//
//  Created by Abhinav Bhardwaj on 2020-04-08.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase
import Kingfisher

var imgArr = [String]()
class ObjectDescVC: UIViewController {
    
    @IBOutlet weak var ObjectImageView: UIImageView!
    @IBOutlet weak var descText: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var imageName:String?
    var docId:String?
    var liked:Bool = false
    var del_CustomerHomeVC : CustomerHomeVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showData()
        
    }
    func showData(){
        let db = Firestore.firestore()
        let collection = db.collection("uploaded data").document(docId!)
        collection.getDocument { (document, error) in
            if let document = document, document.exists {
                self.titleLabel.text = document.data()!["title"] as! String
                self.descText.text = document.data()!["description"] as! String
            } else {
                print("Document does not exist")
            }
        }
        
        let imagePath = Storage.storage().reference().child(imageName!)
        imagePath.downloadURL { (url, error) in
            if let error = error{
                print("error fetching url \(error.localizedDescription)")
                return
            }
            
            guard let url = url else{
                return
            }
            let resource = ImageResource(downloadURL: url)
            self.ObjectImageView.kf.setImage(with: resource)
            
        }
    }
    
    
    @IBAction func tryButtonPressed(_ sender: UIButton) {
        
        if (!CustomerHomeVC.multipleObjMode){
            print("new VC created")
            let destVC = storyboard?.instantiateViewController(identifier: "arVC") as! ArVC
            destVC.docToOpen = docId
            navigationController?.pushViewController(destVC, animated: true)
            
          }else{
            print("old VC used")
            navigationController?.popViewController(animated: true)
            del_CustomerHomeVC?.tryBtnPressed = true
            del_CustomerHomeVC?.del_ARVC?.docToOpen = docId
            
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let savedImage = saveImage(UIImage(named: docId!)!)
        
        if savedImage {
            imgArr.append(docId!)
            alert(title: "Saved !", message: "Image Saved Successfully", buttonTitle: "OK")
        }
        else{
            alert(title: "Warning !", message: "Error saving image", buttonTitle: "OK")
        }
        
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        if(!liked){
            likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likeBtn.tintColor = #colorLiteral(red: 0, green: 0.5185523033, blue: 1, alpha: 1)
            liked = true
        }
            
        else if(liked){
            likeBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            likeBtn.tintColor = #colorLiteral(red: 0, green: 0.5185523033, blue: 1, alpha: 1)
            liked = false
        }
        
    }
    
    func saveImage( _ image: UIImage)-> Bool{
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(docId!).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    func alert(title: String , message: String , buttonTitle: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}


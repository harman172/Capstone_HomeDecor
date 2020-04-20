//
//  CustomerHomeVC.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-11.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import Kingfisher

class CustomerHomeVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var savedImgBtn: UIButton!
    static var username:String?
    static var multipleObjMode = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    var documentIDs = [String]()
    
    @IBOutlet weak var wishBtn: UIButton!
//    let items:[String] = ["table" , "chair" , "couch"]
    var items = [String]()
    var docs = [URL]()
    var tempArray = [String]()
    var tryBtnPressed: Bool?
    var del_ARVC: ArVC?
   

    override func viewDidLoad() {
        tryBtnPressed = false
        super.viewDidLoad()
        wishBtn.layer.cornerRadius = 10
        savedImgBtn.layer.cornerRadius = 10
        loadImages()
        loadFiles()
//        print("count...\(Constants.items.count)")
        
        
    }
    
    func loadImages(){
        let db = Firestore.firestore()
        
        // get all business account's ids
        db.collection("business").getDocuments { (snapshot, err) in
            
            if let err = err{
                print("something is wrong here. \(err.localizedDescription)")
                return
            }
            
            for document in snapshot!.documents {
                print("------------------------------")
                print("document id: \(document.documentID)")
                let storageRef = Storage.storage().reference()
                    .child("Uploaded Images")
                    .child(document.documentID)
                storageRef.listAll { (result, error) in
                    if let error = error{
                        print("error..\(error.localizedDescription)")
                        return
                    }
                    
                    for item in result.items{
                        print("item: \(item.fullPath)")
                        self.tempArray.append(item.fullPath)
                        self.items = self.tempArray
                        print("this count...\(self.items.count).....\(self.tempArray.count)")
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func loadFiles(){
        let db = Firestore.firestore()
        db.collection("business").getDocuments { (snapshot, err) in
            if let err = err{
                print("something is wrong here. \(err.localizedDescription)")
                return
            }
            
            for document in snapshot!.documents {
                print("------------------------------")
                print("document id: \(document.documentID)")
                let storageRef = Storage.storage().reference()
                    .child("Uploaded Files")
                    .child(document.documentID)
                storageRef.listAll { (result, error) in
                    if let error = error{
                        print("error..\(error.localizedDescription)")
                        return
                    }
                    
                    for item in result.items{
                        print("item: \(item.fullPath)")
//                        self.tempArray.append(item.fullPath)
//                        self.items = self.tempArray
//                        print("this count...\(self.items.count).....\(self.tempArray.count)")
//                        self.collectionView.reloadData()
                    }
                }
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        loadImages()
       // navigationItem.setHidesBackButton(true, animated: animated)
        if(CustomerHomeVC.multipleObjMode && tryBtnPressed!){
            
            tryBtnPressed = false
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("changed count...\(items.count)")
      return items.count
     }
         
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomerHomeViewCell
        
        //fetch images
        let imagePath = Storage.storage().reference().child(items[indexPath.row])
        imagePath.downloadURL { (url, error) in
            if let error = error{
                print("error fetching url \(error.localizedDescription)")
                return
            }
            
            guard let url = url else{
                return
            }
            let resource = ImageResource(downloadURL: url)
            cell.ImageViewCell.kf.setImage(with: resource) { (result) in
                switch result{
                case .success(_):
                    print("Success downloading image")
                    
                case .failure(let err):
                    print("switch error...\(err.localizedDescription)")
                }
            }
        }
//        cell.ImageViewCell.image = UIImage(named: items[indexPath.row])
        return cell
     }
       // MARK: For cell size WRT screen size
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

          let height = view.frame.size.height
          let width = view.frame.size.width

          return CGSize(width: width * 0.47, height: height * 0.2)
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let selectedItemName = items[indexPath.row]
          let destVC = storyboard?.instantiateViewController(identifier: "objectDescVC") as! ObjectDescVC

            destVC.imageName = selectedItemName
            destVC.del_CustomerHomeVC = self

          navigationController?.pushViewController(destVC, animated: true)
          
      }
          
      // MARK: Saved Images screen
      @IBAction func savedImgPressed(_ sender: UIButton) {
      let destVC = storyboard?.instantiateViewController(identifier: "savedImagesVC") as! SavedImagesVC
          navigationController?.pushViewController(destVC, animated: true)
      }
      
    @IBAction func logoutPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
           
            let destVC = storyboard?.instantiateViewController(withIdentifier: "loginRegisterVC") as! LoginRegisterVC
            navigationController?.pushViewController(destVC, animated: true)
            
            } catch let err {
                print(err)
        }
        
    }
    
      
      // MARK: Wishlist screen
      @IBAction func wishlistPressed(_ sender: UIButton) {
          //wishlist screen
      }
    

}


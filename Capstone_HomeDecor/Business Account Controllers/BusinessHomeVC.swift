//
//  BusinessHomeVC.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-11.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import Kingfisher

class BusinessHomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadImages(){
        items = [String]()
        let storageRef = Storage.storage().reference().child("Uploaded Images").child(Constants.ID)
        storageRef.listAll { (result, error) in
            if let error = error{
                print("error..\(error.localizedDescription)")
                return
            }
            
            for item in result.items{
                print("item: \(item.fullPath)")
                self.items.append(item.fullPath)
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! BusinessCollectionViewCell
        
        let substring = String(items[indexPath.row].split(separator: "/").last!)
        let db = Firestore.firestore()
        let collection = db.collection("uploaded data").document(substring)
        collection.getDocument { (document, error) in
            if let document = document, document.exists {
                let title = document.data()!["title"] as! String
                cell.cellTitle.text = title
            } else {
                print("Document does not exist")
            }
        }
        
        
        
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
            cell.cellImageView.kf.setImage(with: resource) { (result) in
                switch result{
                case .success(_):
                    print("Success downloading image")
                    
                case .failure(let err):
                    print("switch error...\(err.localizedDescription)")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        return CGSize(width: width * 0.47, height: height * 0.2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let docId = String(items[indexPath.row].split(separator: "/").last!)
        let destVC = storyboard?.instantiateViewController(identifier: "editViewController") as! EditViewController
        destVC.id = docId
        destVC.del_Home = self
        navigationController?.pushViewController(destVC, animated: true)
    }
}

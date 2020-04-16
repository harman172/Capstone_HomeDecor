//
//  CustomerHomeVC.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-11.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import FirebaseAuth

class CustomerHomeVC:UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var savedImgBtn: UIButton!
    static var username:String?
    @IBOutlet weak var wishBtn: UIButton!
    let items:[String] = ["table" , "chair" , "couch"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        wishBtn.layer.cornerRadius = 10
        savedImgBtn.layer.cornerRadius = 10
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return items.count
         }
         
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomerHomeViewCell

          cell.ImageViewCell.image = UIImage(named: items[indexPath.row])

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


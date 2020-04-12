//
//  SavedImagesVC.swift
//  Group P Capstone
//
//  Created by Abhinav Bhardwaj on 2020-04-10.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit

class SavedImagesVC: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    // MARK: For testing only
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return numberOfFile()
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SavedImagesViewCell
       
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let imageURL = URL(fileURLWithPath: paths).appendingPathComponent("\(indexPath.row).png")
        cell.imgViewCell.image = UIImage(contentsOfFile: imageURL.path)
        
    
        
        
        
        return cell
       }
    
    // MARK: For cell size WRT screen size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           let height = view.frame.size.height
           let width = view.frame.size.width
          
           return CGSize(width: width * 0.47, height: height * 0.2)
       }
    
    
    func numberOfFile() ->Int {
        let fileManager = FileManager.default
                  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                  let dirContents = try? fileManager.contentsOfDirectory(atPath: documentsPath)
                  let count = dirContents?.count
                
        return count ?? 0
    }
    
   

}


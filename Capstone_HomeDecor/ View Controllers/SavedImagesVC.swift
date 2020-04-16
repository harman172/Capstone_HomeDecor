//
//  SavedImagesVC.swift
//  Group P Capstone
//
//  Created by Abhinav Bhardwaj on 2020-04-10.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit

class SavedImagesVC: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var noImgView: UIView!
    var imgPaths = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPaths()
        collectionView.reloadData()
        if (numberOfFile() == 0){
            noImgView.isHidden = false
        }
    }
    // MARK: For testing only
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return numberOfFile()
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SavedImagesViewCell
       
        
        
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let imageURL = URL(fileURLWithPath: paths).appendingPathComponent("\(indexPath.row).png")
//        cell.imgViewCell.image = UIImage(contentsOfFile: imageURL.path)
        cell.imgViewCell.image = UIImage(contentsOfFile: imgPaths[indexPath.row])
        return cell
       }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
           let selectedFile = imgPaths[indexPath.row]
            
            let destVC = storyboard?.instantiateViewController(withIdentifier: "imageVC") as! ImageVC
            destVC.imgPath = selectedFile
            navigationController?.pushViewController(destVC, animated: true)
            
        
        }
    
    
    
    
    // MARK: For cell size WRT screen size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           let height = view.frame.size.height
           let width = view.frame.size.width
          
           return CGSize(width: width * 0.47, height: height * 0.2)
       }
    
    
    func numberOfFile() ->Int {
                    let fileManager = FileManager.default
        
         let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
        
        let newdir = directory!.appendingPathComponent("\(CustomerHomeVC.username!)")
        let dirContents = try? fileManager.contentsOfDirectory(atPath: newdir!.path)
              
                  let count = dirContents?.count
                
        return count ?? 0
    }
    
    func getPaths() {
        imgPaths = [String]()
        for i in 0..<numberOfFile(){
//            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
            let fileManager = FileManager.default
            let newdir = directory!.appendingPathComponent("\(CustomerHomeVC.username!)")
            let dirContents = try? fileManager.contentsOfDirectory(atPath: newdir!.path)
            let imageURL = URL(fileURLWithPath: newdir!.path).appendingPathComponent("\(dirContents![i])")
           
            print(imageURL)
            
            imgPaths.append(imageURL.path)
           
        }
        

    }
   

}


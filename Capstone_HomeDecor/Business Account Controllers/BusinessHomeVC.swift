//
//  BusinessHomeVC.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-11.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class BusinessHomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let items:[String] = ["table" , "chair" , "couch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let nib = UINib(nibName: "BusinessGridViewCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "gridCell")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! BusinessCollectionViewCell
//        cell.setData(image: items[indexPath.row], title: items[indexPath.row])
        cell.cellImageView.image = UIImage(named: items[indexPath.row])
        cell.cellTitle.text = items[indexPath.row]
        return cell
      }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        return CGSize(width: width * 0.47, height: height * 0.2)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

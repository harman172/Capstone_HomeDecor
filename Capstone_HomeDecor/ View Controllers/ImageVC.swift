//
//  ImageVC.swift
//  Capstone_HomeDecor
//
//  Created by Abhinav Bhardwaj on 2020-04-13.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var imgPath:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = UIImage(contentsOfFile: imgPath!)
        
    }
    

    

}

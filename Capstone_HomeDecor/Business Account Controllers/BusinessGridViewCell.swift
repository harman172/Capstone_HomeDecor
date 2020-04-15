//
//  BusinessGridViewCell.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-15.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class BusinessGridViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(image: String, title: String){
        cellImageView.image = UIImage(named: image)
        cellTitle.text = title
    }

}

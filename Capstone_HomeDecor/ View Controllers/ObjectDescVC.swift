//
//  ObjectDescVC.swift
//  Group P Capstone
//
//  Created by Abhinav Bhardwaj on 2020-04-08.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit
var imgArr = [String]()
class ObjectDescVC: UIViewController {

    @IBOutlet weak var ObjectImageView: UIImageView!
    
    
    @IBOutlet weak var descText: UITextView!
    
    
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var imageName:String?
    var liked:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ObjectImageView.image = UIImage(named: imageName!)
    }
    

    @IBAction func tryButtonPressed(_ sender: UIButton) {
        
        let destVC = storyboard?.instantiateViewController(identifier: "arVC") as! ArVC
        destVC.nodeName = imageName
        navigationController?.pushViewController(destVC, animated: true)
        
        
        print(imageName!)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        
      let savedImage = saveImage(UIImage(named: imageName!)!)
        
        if savedImage {
            imgArr.append(imageName!)
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
            try data.write(to: directory.appendingPathComponent("\(imageName!).png")!)
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


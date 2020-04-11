//
//  ViewController.swift
//  a
//
//  Created by Parth Dalwadi on 2020-04-08.
//  Copyright © 2020 Parth Dalwadi. All rights reserved.
//

import UIKit

class LoginRegisterVC: UIViewController {

    
    @IBOutlet weak var loginRegBtn: UIButton!
    @IBOutlet weak var loginRegNavBtn: UIButton!
    
    // text field outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var userType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func navigationBtnPressed(_ sender: UIButton) {
        
        
    if(loginRegBtn.titleLabel?.text == "Login"){
        
        // going to register screen
    loginRegBtn.setTitle("Register", for: .normal)
    loginRegNavBtn.setTitle("Already Have Account? Login", for: .normal)
        nameTF.isHidden = false
        phoneNoTF.isHidden = false
        userType.isHidden = false
    }else{
        
        // going to login screen
        
    loginRegBtn.setTitle("Login", for: .normal)
    loginRegNavBtn.setTitle("Dont Have an Account ? Register", for: .normal)
        
        nameTF.isHidden = true
        phoneNoTF.isHidden = true
        userType.isHidden = true
        }
        
    }
    
}


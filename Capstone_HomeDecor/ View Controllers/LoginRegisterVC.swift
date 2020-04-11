//
//  ViewController.swift
//  a
//
//  Created by Parth Dalwadi on 2020-04-08.
//  Copyright © 2020 Parth Dalwadi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class LoginRegisterVC: UIViewController {

    
    @IBOutlet weak var loginRegBtn: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
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

    func validateFields() -> String?{
        if(loginRegBtn.titleLabel?.text == "Register"){
            if (nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                phoneNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                return "All the fields are required"
            }
        } else if(loginRegBtn.titleLabel?.text == "Login"){
            if (emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                return "All the fields are required"
            }
        }
        
        return nil
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        if(loginRegBtn.titleLabel?.text == "Login"){
            loginRegBtn.setTitle("Register", for: .normal)
            textLabel.text = "Already have an account? "
            toggleButton.setTitle("Login", for: .normal)
            nameTF.isHidden = false
            phoneNoTF.isHidden = false
            userType.isHidden = false
            
        } else if(loginRegBtn.titleLabel?.text == "Register"){
            loginRegBtn.setTitle("Login", for: .normal)
            textLabel.text = "Don't have an account? "
            toggleButton.setTitle("Create account", for: .normal)
            nameTF.isHidden = true
            phoneNoTF.isHidden = true
            userType.isHidden = true
            
            
            
        }
    }
    
    @IBAction func loginRegTapped(_ sender: UIButton) {
        let validation = validateFields()
        if validation != nil{
            errorLabel.isHidden = false
            errorLabel.text = validation
        }
        if(loginRegBtn.titleLabel?.text == "Login"){
            errorLabel.isHidden = true
        } else if(loginRegBtn.titleLabel?.text == "Register"){
            errorLabel.isHidden = true
            let name = nameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let  phone = phoneNoTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let err = error{
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = err.localizedDescription
                } else{
                    var accountType = "business"
                    if(self.userType.selectedSegmentIndex == 0){
                        accountType = "customer"
                    }
                    
                    //store in database
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["name":name, "phone":phone, "password":password, "uid":result!.user.uid, "account type":accountType]) { (error) in
                        if error == nil{
                            var homeViewController : UIViewController?
                            if accountType == "business"{
                                homeViewController = self.storyboard?.instantiateViewController(identifier: "BusinessVC") as? BusinessHomeVC
                            } else{
                                homeViewController = self.storyboard?.instantiateViewController(identifier: "CustomerVC") as? CustomerHomeVC
                            }
                            self.view.window?.rootViewController = homeViewController
                            self.view.window?.makeKeyAndVisible()
                        } else{
                            print(error!.localizedDescription)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    
    /*
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
 */
    
}


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
        
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            if let accountType = UserDefaults.standard.string(forKey: "accountType"){
                Constants.ID = uid
                Constants.ACCOUNT_TYPE = accountType
                transitionToHomeScreen(accountType)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func validateFields() -> String?{
        if(loginRegBtn.titleLabel?.text == "Register"){
            if (nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                phoneNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                return "All the fields are required"
            }
            if isPasswordValid(passwordTF.text!) == false{
                return "Password must contain a special character and a number"
            }
        } else if(loginRegBtn.titleLabel?.text == "Login"){
            if (emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                return "All the fields are required"
            }
        }
        return nil
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
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
        } else{
            if(loginRegBtn.titleLabel?.text == "Login"){
                errorLabel.isHidden = true
                let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil{
                        
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = error!.localizedDescription
                    } else{
//                        let username = result!.user.email!.components(separatedBy: "@")
//                        CustomerHomeVC.username = username[0]
                        
                        let db = Firestore.firestore()
                        
                        let businessAccount = db.collection("business").document(result!.user.uid)
                        
                        businessAccount.getDocument { (document, error) in
                            if let document = document, document.exists{
                                UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
                                UserDefaults.standard.setValue("business", forKey: "accountType")
                                Constants.ID = UserDefaults.standard.string(forKey: "uid")!
                                Constants.ACCOUNT_TYPE = UserDefaults.standard.string(forKey: "accountType")!
                                self.transitionToHomeScreen("business")
                            } else{
                                print("document does not exist")
                                
                                let customerAccount = db.collection("customer").document(result!.user.uid)
                                customerAccount.getDocument { (document, error) in
                                    if let document = document, document.exists{
                                        UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
                                        UserDefaults.standard.setValue("customer", forKey: "accountType")
                                        Constants.ID = UserDefaults.standard.string(forKey: "uid")!
                                        Constants.ACCOUNT_TYPE = UserDefaults.standard.string(forKey: "accountType")!
                                        self.transitionToHomeScreen("customer")
                                    } else{
                                        print("document does not exist")
                                        self.errorLabel.isHidden = false
                                        self.errorLabel.text = "No such account exists! Please create one"
                                    }
                                }
                            }
                        }
                    }
                }
                
                
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
                        db.collection(accountType).document(result!.user.uid).setData(["name":name, "phone":phone, "password":password]) { (error) in
                            if error != nil{
                                print("Error writing document")
                            } else{
                                UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
                                UserDefaults.standard.setValue(accountType, forKey: "accountType")
                                Constants.ID = UserDefaults.standard.string(forKey: "uid")!
                                Constants.ACCOUNT_TYPE = UserDefaults.standard.string(forKey: "accountType")!
                                self.transitionToHomeScreen(accountType)
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func transitionToHomeScreen(_ accountType: String){
        var homeViewController : UIViewController?
        if accountType == "business"{
            homeViewController = storyboard?.instantiateViewController(identifier: "ContainerVC") as? ContainerViewController
        } else{
            homeViewController = storyboard?.instantiateViewController(identifier: "CustomerVC") as? CustomerHomeVC
        }
        navigationController?.pushViewController(homeViewController!, animated: true)
        //        view.window?.rootViewController = homeViewController
        //        view.window?.makeKeyAndVisible()
    }
    
    
    
}


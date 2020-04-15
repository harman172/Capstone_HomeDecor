//
//  ContainerViewController.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-14.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    let transition = SlideInTransition()
    @IBOutlet weak var navItem: UINavigationItem!
    
    lazy var businessViewController: BusinessHomeVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "businessVC") as! BusinessHomeVC
        self.addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()

    lazy var addNewViewController: AddNewItemViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "addObjectVC") as! AddNewItemViewController
        self.addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        transitionToNewContent(MenuType.home)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "menuTVC") as? SideMenuTableViewController else { return }
        
        menuViewController.didTapMenuType = {
            menuType in
            self.transitionToNewContent(menuType)
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        
        self.present(menuViewController, animated: true)
    }
    
    func transitionToNewContent(_ menuType: MenuType){
        let title = String(describing: menuType).capitalized
        self.title = title
//        self.navItem.title = title
        
        if title == "Home"{
            businessViewController.view.isHidden = false
            addNewViewController.view.isHidden = true
        } else if title == "Addnewobject"{
            businessViewController.view.isHidden = true
            addNewViewController.view.isHidden = false
        }
        
    }
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChild(childViewController)
        
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParent: self)
    }

}

extension ContainerViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
}

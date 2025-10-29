//
//  SplashVC.swift
//  Project
//
//  Created by VnPaz on 3/12/25.
//

import Foundation
import UIKit

class SplashVC : UIViewController {
    
    var isUserValid : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line," ")
        
        
        // check user status
        
        isUserValid = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            if (self.isUserValid) {
                
                let tabbar : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
                
                self.navigationController?.pushViewController(tabbar, animated: true)
                
            } else {
                
                let mainVC : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginAndRegister")
                
                self.navigationController?.pushViewController(mainVC, animated: false)
            }
        })
        
        
    }
}

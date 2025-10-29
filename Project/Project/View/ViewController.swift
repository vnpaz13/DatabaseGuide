//
//  ViewController.swift
//  Project
//
//  Created by VnPaz on 3/10/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func signInButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let moveSI = storyboard.instantiateViewController(withIdentifier: "SignIn") as? SignInView {
            self.navigationController?.pushViewController(moveSI, animated: true)
        }
    }
    
    @IBAction func signUPButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let moveSU = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignUpView {
            self.navigationController?.pushViewController(moveSU, animated: true)
        }
    }
    
    
}

extension UIViewController {
    
    func loadBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle(" 뒤로", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "SF Pro Text", size: 17) ?? UIFont.systemFont(ofSize: 17)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(red: 22/255, green: 23/255, blue: 23/255, alpha: 1.0)
        backButton.addTarget(self, action: #selector(confirmBack), for: .touchUpInside)
        backButton.sizeToFit()
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc private func confirmBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func keyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


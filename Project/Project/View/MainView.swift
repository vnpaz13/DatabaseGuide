//
//  MainView.swift
//  Project
//
//  Created by VnPaz on 3/12/25.
//

import UIKit

class MainView: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        SupabaseManager.shared.client
    }
    


}

//
//  DGBaseViewController.swift
//  DaignalT
//
//  Created by Datamatics on 16/11/22.
//

import UIKit
// MARK: - Base View Controller to handle comman UIViewController functionality.
class DGBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Method to handle BackButton which will pop the view controller.
    var backButton: UIBarButtonItem {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(backButtonTapped))
        return barButton
    }
    
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

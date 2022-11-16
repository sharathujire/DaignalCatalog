//
//  ViewController.swift
//  DaignalT
//
//  Created by Datamatics on 15/11/22.
//

import UIKit
// MARK: - Main View controller which is of type Dashboard from where user can navigate to next screen.
class DGMainViewController: DGBaseViewController {
    @IBOutlet weak var goToCatalogue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    // Method to setuo the Main View Controller.
    private func setUpView() {
        self.goToCatalogue.setTitle( DGConst.DGGoToCatalogue, for: .normal)
        self.goToCatalogue.titleLabel?.font = UIFont(name: DGFontStyle.titilliumWebSemiBold.rawValue, size: 20.0)
        self.goToCatalogue.layer.cornerRadius = 10.0
        self.view.backgroundColor = .black
    }
    
    // Method the push Catalogue View Controller.
    @IBAction func goToCatalogue(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: DGStoryboard.DGCatalogue, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: DGViewController.DGCatalogueViewController)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


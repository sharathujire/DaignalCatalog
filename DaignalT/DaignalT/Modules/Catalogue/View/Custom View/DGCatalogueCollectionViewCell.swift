//
//  DGCatalogueCollectionViewCell.swift
//  DaignalT
//
//  Created by Datamatics on 15/11/22.
//

import UIKit
// MARK: - Collection View Cell to display Catalogue items.
class DGCatalogueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpCatalogueView()
    }

    // Method the setup initail view for Catalogue.
    private func setUpCatalogueView() {
        self.bgView.backgroundColor = .black
        self.posterTitleLabel.textColor = .white
        self.posterTitleLabel.textAlignment = .left
        self.posterTitleLabel.font = UIFont(name: DGFontStyle.titilliumWebLight.rawValue, size: 18.0)
    }

    // Method to Set Image and Title for the Catalogue.
    func setImageAndTitle(imageName: String?, title: String?) {
        if let imageString = imageName, let image = UIImage(named: imageString) {
            self.posterImageView.image = image
        } else {
            self.posterImageView.image = UIImage(named: "placeholder_for_missing_posters.png")
        }
        self.posterTitleLabel.text = title ?? "--"
    }
}

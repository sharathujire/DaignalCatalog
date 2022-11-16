//
//  CatalogueViewController.swift
//  DaignalT
//
//  Created by Datamatics on 15/11/22.
//

import UIKit
// MARK: - Catalogue View Controller to show the Catalogue items.
class DGCatalogueViewController: DGBaseViewController, DGCatalogueViewModelDelegate {
    @IBOutlet weak var catalogueCollectionView: UICollectionView!
    
    var catalogueViewModel = DGCatalogueViewModel()
    let searchBar = UISearchBar()
    private let sectionInsets = UIEdgeInsets(top: 18.0, left: 15.0, bottom: 18.0, right: 15.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBackButtonTitleAndSearch()
        self.configureSearchBar()
    }

    // Method to set up the Catalogue View Controller
    private func setUpView() {
        self.view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "nav_bar")
        self.navigationController?.navigationBar.tintColor = .white
        self.catalogueViewModel.delegate = self
        self.getCatalogueItems()
        self.setupCatalogueCollectionView()
    }

    // Register the nib class files to Catalogue View Controller
    private func setupCatalogueCollectionView() {
        self.catalogueCollectionView.delegate = self
        self.catalogueCollectionView.dataSource = self
        self.catalogueCollectionView.showsHorizontalScrollIndicator = false
        self.catalogueCollectionView.showsVerticalScrollIndicator = true
        self.catalogueCollectionView.backgroundColor = .black
        self.catalogueCollectionView.keyboardDismissMode = .onDrag
        self.catalogueCollectionView.register(UINib(nibName: DGCatalogueModule.DGCatalogueCollectionViewCell,
                                                    bundle: nil), forCellWithReuseIdentifier: DGCatalogueModule.DGCatalogueCollectionViewCell)
    }

    // Method to add Navigation Title, Search Bar and Back button.
    func showBackButtonTitleAndSearch() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: DGFontStyle.titilliumWebSemiBold.rawValue, size: titleLabel.font.pointSize + 4)
        titleLabel.text = self.catalogueViewModel.navigationTitle
        let titleLabelItem = UIBarButtonItem.init(customView: titleLabel)
        let searchBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(searchBarButtonTapped))
        self.navigationItem.leftBarButtonItems = [self.backButton, titleLabelItem]
        self.navigationItem.rightBarButtonItem = searchBarButton
    }

    // Method get Catalogue Items from View Model Class.
    private func getCatalogueItems() {
        self.catalogueViewModel.fetchCatalogueItems()
    }

    // Method to reload Catalogue grid.
    func reloadData() {
        self.catalogueCollectionView.reloadData()
    }
}

// MARK: - Catalogue Collection View delegate and data source methods.
extension DGCatalogueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catalogueViewModel.numberOfCatalogueItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.catalogueCollectionView.dequeueReusableCell(withReuseIdentifier:
                                                                            DGCatalogueModule.DGCatalogueCollectionViewCell,
                                                                          for: indexPath) as? DGCatalogueCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.setImageAndTitle(imageName: self.catalogueViewModel.catalogueItems[indexPath.row].posterImage, title: self.catalogueViewModel.catalogueItems[indexPath.row].name)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:  IndexPath) -> CGSize {

        let paddingSpacing = sectionInsets .right + sectionInsets .left + (self.catalogueViewModel.cellSpacing * 2)
        let widthAvailable = view.safeAreaLayoutGuide.layoutFrame.size.width - paddingSpacing
        let widthPerItem  = widthAvailable / 3
        self.catalogueViewModel.widthOfCell = widthPerItem
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.catalogueViewModel.minimumSpacing
    }
}

// MARK: Handling search bar and scroll actions
extension DGCatalogueViewController: UIScrollViewDelegate, UISearchBarDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= self.self.catalogueViewModel.minimumSpacing * 4 {
            self.getCatalogueItems()
        }
    }

    func configureSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = DGConst.DGSearchByName
        self.searchBar.searchTextField.font = UIFont(name: DGFontStyle.titilliumWebLight.rawValue, size: 18.0)
        self.searchBar.showsCancelButton = true
    }

    @objc
    func searchBarButtonTapped() {
        self.navigationItem.titleView = self.searchBar
        self.searchBar.searchTextField.becomeFirstResponder()
        self.navigationItem.leftBarButtonItems = [self.backButton]
        self.navigationItem.rightBarButtonItems = []
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.catalogueViewModel.searchText = searchText
        self.catalogueViewModel.fetchCatalogueItemsWithSearch()
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.catalogueViewModel.searchText = searchText
        self.catalogueViewModel.fetchCatalogueItemsWithSearch()
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.catalogueViewModel.emptySearchText()
        self.catalogueViewModel.fetchCatalogueItemsWithSearch()
        self.searchBar.resignFirstResponder()
        return false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.searchTextField.text = ""
        self.catalogueViewModel.emptySearchText()
        self.catalogueViewModel.fetchCatalogueItemsWithSearch()
        self.navigationItem.titleView = nil
        self.showBackButtonTitleAndSearch()
    }
}

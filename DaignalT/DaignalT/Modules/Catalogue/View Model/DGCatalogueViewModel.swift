//
//  DGCatalogueViewModel.swift
//  DaignalT
//
//  Created by Datamatics on 15/11/22.
//

import Foundation
// MARK: - Protocol delegate to handle Catalogue ViewModel task completion.
protocol DGCatalogueViewModelDelegate: AnyObject {
    func reloadData()
}

// MARK: - Catalogue View Model Class to handle Catlogue Bussines logics.
class DGCatalogueViewModel {
    var numberOfCatalogueItems = 0
    var catalogueItems: [DGCatalogueContent] = [] {
        didSet {
            self.numberOfCatalogueItems = catalogueItems.count
        }
    }
    
    var dCatalogueItems: [DGCatalogueContent] = []
    var delegate: DGCatalogueViewModelDelegate?
    let cellSpacing = 15.0
    let minimumSpacing = 18.0
    var widthOfCell = 0.0
    var searchText = ""
    var navigationTitle = ""
    var page = 0
    var currentPage = 0
    let totalPage = 3
    
    // Method to fetch Catalogue Items from Json file.
    func fetchCatalogueItems() {
        var jsonFile = ""
        if self.currentPage == self.totalPage {
            return
        } else {
            self.page = self.currentPage + 1
        }
        
        switch self.page {
        case 1:
            jsonFile = "CONTENTLISTINGPAGE-PAGE1"
        case 2:
            jsonFile = "CONTENTLISTINGPAGE-PAGE2"
        case 3:
            jsonFile = "CONTENTLISTINGPAGE-PAGE3"
        default:
            return
        }
        
        // To load data from local json file
        DGJsonUtility.loadDataFromJsonFile(jsonFileName: jsonFile,
                                           type: DGCatalogueData.self) {  error, modelObject in
            if let catalogueData = modelObject {
                self.navigationTitle = catalogueData.title ?? ""
                self.dCatalogueItems = self.catalogueItems + (catalogueData.contentItems?.content ?? [])
                self.fetchCatalogueItemsWithSearch()
                self.currentPage = catalogueData.pageNum ?? (self.currentPage + 1)
            } else if let error = error {
                print(error)
            }
        }
    }
    
    // Method to Filter out the Catalogue item based on search criteria.
    func fetchCatalogueItemsWithSearch() {
        if self.searchText.isEmpty {
            self.catalogueItems.removeAll()
            for data in self.dCatalogueItems {
                self.catalogueItems.append(data)
            }
        } else {
            self.catalogueItems = dCatalogueItems.filter { (catalogueItems: DGCatalogueContent) -> Bool in
                let itemsMatch = catalogueItems.name?.range(of: self.searchText, options: NSString.CompareOptions.caseInsensitive)
                return itemsMatch != nil
            }
        }
        self.delegate?.reloadData()
    }
    
    // Method to emty the search text once search text is cleared from Search Bar.
    func emptySearchText() {
        self.searchText = ""
    }
}

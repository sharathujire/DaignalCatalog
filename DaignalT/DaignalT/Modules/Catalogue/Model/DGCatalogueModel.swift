//
//  DGCatalogueModel.swift
//  DaignalT
//
//  Created by Datamatics on 15/11/22.
//

import Foundation

// MARK: - DGCatalogueModel.
struct DGCatalogueModel: Codable {
    let page: DGCatalogueData?
}

// MARK: - CatalogueData.
struct DGCatalogueData: Codable {
    let totalContentItems, pageNum, pageSize: Int?
    let title: String?
    let contentItems: DGCatalogueItems?

    enum CodingKeys: String, CodingKey {
        case title
        case totalContentItems = "total-content-items"
        case pageNum = "page-num"
        case pageSize = "page-size"
        case contentItems = "content-items"
    }
}

// MARK: - CatalogueContentItems.
struct DGCatalogueItems: Codable {
    let content: [DGCatalogueContent]?
}

// MARK: - CatalogueContent.
struct DGCatalogueContent: Codable {
    let name, posterImage: String?

    enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }
}

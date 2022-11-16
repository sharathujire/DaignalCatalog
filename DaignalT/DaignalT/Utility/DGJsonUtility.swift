//
//  DGJsonUtility.swift
//  DaignalT
//
//  Created by Datamatics on 15/11/22.
//

import Foundation
// MARK: - JsonUtility class to parse json data.
class DGJsonUtility {

    /// Generic Method to load json data
    /// - Parameters:
    ///   - jsonFileName: json file name to be loaded
    ///   - type: Model type
    ///   - completionHandler: To pass error or decoded model object
    class func loadDataFromJsonFile<T: Decodable>(jsonFileName: String, type: T.Type, completionHandler: @escaping (_ error: String?, _ modelObject: T?) -> Void) {
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let respData = json?["page"] as? [String: Any] {
                    let jsonData = try JSONSerialization.data(withJSONObject: respData, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let model = try JSONDecoder().decode(T.self, from: jsonData)
                    completionHandler(nil, model)
                }
            } catch let error {
                debugPrint("Error: \(error)")
                completionHandler(error.localizedDescription, nil)
            }
        } else {
            debugPrint("Wrong JSON File")
            completionHandler("Wrong JSON File", nil)
        }
    }
}

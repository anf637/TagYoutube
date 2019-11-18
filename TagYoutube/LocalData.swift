//
//  LocalData.swift
//  TagYoutube
//
//  Created by 이승희 on 18/11/2019.
//

import Foundation


class LocalData {
    
    func saveTmsPushServerType (value: PushProperty) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(encodedData, forKey: "")
        UserDefaults.standard.synchronize()
    }
    
    func getTmsPushServerType() -> PushProperty? {
        if let result = UserDefaults.standard.data(forKey: "") {
            if let decodedData = NSKeyedUnarchiver.unarchiveObject(with: result) as? PushProperty{
                return decodedData
            }
        }
        return nil
    }
}


class PushProperty : NSObject, NSCoding {
    
    var serverType: Int
    var apiUrl: String
    var appKey: String
    
    init(serverType: Int, apiUrl: String, appKey: String) {
        self.apiUrl = apiUrl
        self.appKey = appKey
        self.serverType = serverType
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(serverType, forKey: "serverType")
        aCoder.encode(apiUrl, forKey: "apiUrl")
        aCoder.encode(appKey, forKey: "appKey")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let serverType = aDecoder.decodeInteger(forKey: "serverType")
        let apiUrl = aDecoder.decodeObject(forKey: "apiUrl") as! String
        let appKey = aDecoder.decodeObject(forKey: "appKey") as! String
        
        self.init(serverType: serverType, apiUrl: apiUrl, appKey: appKey)
    }
}

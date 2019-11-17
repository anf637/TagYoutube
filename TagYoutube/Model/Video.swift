//
//  Video.swift
//  TagYoutube
//
//  Created by insung on 2019/11/16.
//

import Foundation
import ObjectMapper

class Video: Mappable {
    
    
    var etag: String?
    var items: [Item]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        etag <- map["etag"]
        items <- map["items"]
    }
    
    class Item: Mappable {
        var etag: String?
        var kind: String?
        var snippet: Snippet?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            etag <- map["etag"]
            kind <- map["kind"]
            snippet <- map["snippet"]
        }
    }
    
    class Snippet: Mappable {
        
        var title: String?
        var description: String?
        ////var thumbnails: Thumbnails?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            title <- map["title"]
            description <- map["description"]
            //thumbnails <- map["thumbnails"]
        }
    }
    
    
    class Thumbnails: Mappable {
        
        var url: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            url <- map["url"]
        }
    }
    

    
}

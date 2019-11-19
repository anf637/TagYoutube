//
//  File.swift
//  TagYoutube
//
//  Created by insung on 2019. 11. 15..
//
//

import Foundation
import ObjectMapper

class Commnet: Mappable {
    
    var etag: String?
    var items: [item]?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        etag <- map["etag"]
        items <- map["items"]
    }
    
    class item: Mappable {
        
        var kind: String?
        var snippet: Snippet?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            kind <- map["kind"]
            snippet <- map["snippet"]
        }
    }
    
    class Snippet: Mappable {
        
        var canReply: Bool?
        var isPublic: Bool?
        var topLevelComment: topLevelComment?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            canReply <- map["canReply"]
            isPublic <- map["isPublic"]
            topLevelComment <- map["topLevelComment"]
        }
    }
    
    class topLevelComment: Mappable {
        
        var etag: String?
        var kind: String?
        var topLevelCommentSnippet:topLevelCommentSnippet?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            etag <- map["etag"]
            kind <- map["kind"]
            topLevelCommentSnippet <- map["snippet"]
        }
    }
    
    
    class topLevelCommentSnippet: Mappable {
        
        var authorDisplayName: String?
        var updatedAt: String?
        var textOriginal: String?
        var authorProfileImageUrl: String?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            authorDisplayName <- map["authorDisplayName"]
            updatedAt <- map["updatedAt"]
            textOriginal <- map["textOriginal"]
            authorProfileImageUrl <- map["authorProfileImageUrl"]
        }
    }
}


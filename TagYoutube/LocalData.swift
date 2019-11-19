//
//  LocalData.swift
//  TagYoutube
//
//  Created by 이승희 on 18/11/2019.
//

import Foundation
import RealmSwift

class DB_Snippet: Object {
    @objc dynamic var videoId = ""
    @objc dynamic var videoThumbnail = ""
    @objc dynamic var videoDescription: String = ""
    var comment = List<DB_Comment>()
}

class DB_Comment: Object {
    @objc dynamic var authorProfileImageUrl = ""
    @objc dynamic var textOriginal = ""
}

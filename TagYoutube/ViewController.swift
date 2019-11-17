//
//  ViewController.swift
//  TagYoutube
//
//  Created by insung on 2019. 11. 15..
//
//

import UIKit

import UIKit
import Alamofire
import GoogleSignIn
import Alamofire_SwiftyJSON
import AlamofireObjectMapper
import SwiftyJSON
class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var commentArr:[Commnet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
        var url = "https://youtu.be/KoiOE5EXcoI"
        
        
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //api test
    @IBAction func search(_ sender: Any) {
        
//        let parameters: Parameters = ["part":"snippet",
//                                      "videoId":"KoiOE5EXcoI",
//                                      "order":"relevance",
//                                      "key":"AIzaSyDaNppOEh7IXvmv-Su0WgW4HexUaUE0dvE"]
//        let url = "https://www.googleapis.com/youtube/v3/commentThreads"
//
//        Alamofire.request(url,
//                          method: .get,
//                          parameters: parameters,
//                          encoding: URLEncoding.default)
//            .responseObject { (res:DataResponse<Commnet>) in
//                let result = res.result.value
//                result?.items?.forEach({ (item) in
//                    print(item.snippet?.topLevelComment?.topLevelCommentSnippet?.authorDisplayName ?? "")
//                    print(item.snippet?.topLevelComment?.topLevelCommentSnippet?.textOriginal ?? "")
//                })
//
//        }
        
        let param: Parameters = ["part":"snippet",
                                 "id":"KoiOE5EXcoI",
                                 "key":"AIzaSyDaNppOEh7IXvmv-Su0WgW4HexUaUE0dvE"]
        let url = "https://www.googleapis.com/youtube/v3/videos"
        Alamofire.request(url,
                      method: .get,
                      parameters: param,
                      encoding: URLEncoding.default)
        .responseObject { (res:DataResponse<Video>) in
            let result = res.result.value
            result?.items?.forEach({ (item) in
                print(item.snippet?.description)
            })
        }

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
    
}



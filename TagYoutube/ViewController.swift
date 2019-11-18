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
    //UI
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var commentArr:[Commnet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
        self.searchBar.delegate = self
    
        
        if let theString = UIPasteboard.general.string {
            print("문자를 가져와버렸!!! \(theString)")
        }
    
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
        
       

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        self.present(searchVC!, animated: true, completion: nil)
        return true
    }
}

extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}

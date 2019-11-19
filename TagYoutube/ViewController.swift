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
//import Alamofire_SwiftyJSON
//import AlamofireObjectMapper
import SwiftyJSON
import RealmSwift
import SDWebImage

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var snippetTableView: UITableView!
    
    var snippetArr: [DB_Snippet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
        self.searchBar.delegate = self
        
        snippetArr = [DB_Snippet]()
        let realm = try! Realm()
        let result = realm.objects(DB_Snippet.self)
        for item in result {
            snippetArr?.append(item)
        }
        
        self.snippetTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoredDataCell", for: indexPath) as! StoredDataCell
        let snippet = snippetArr?[indexPath.row]
        cell.videoDescriptionLabel?.text = snippet?.videoDescription
        cell.videoThumbnailImage?.sd_setImage(with: URL(string: snippet?.videoThumbnail ?? ""), completed: nil)
        let comment = snippet?.comment.first
        cell.commentImage?.sd_setImage(with: URL(string: comment?.authorProfileImageUrl ?? ""), completed: nil)
        cell.commentLabel?.text = comment?.textOriginal
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippetArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        searchVC?.detailModeSnippet = snippetArr?[indexPath.row]
        searchVC?.pageMode = .detail
        self.present(searchVC!, animated: true, completion: nil)
    }
}

class StoredDataCell: UITableViewCell {
    @IBOutlet weak var videoThumbnailImage: UIImageView!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
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

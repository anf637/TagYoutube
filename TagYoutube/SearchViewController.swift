//
//  SearchViewController.swift
//  TagYoutube
//
//  Created by insung on 2019/11/16.
//

import UIKit
import Alamofire
import SDWebImage
import RealmSwift
import SwiftyJSON
import AlamofireObjectMapper

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    
    var searchVideoId: String?
    var searchVideoTitle: String?
    var videoDescription: String?
    var videoImageUrl: String?
    var commentArr: [String]?
    var commentImageArr: [String]?
    
    var searchComplete: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchComplete = false
        self.searchTextField.becomeFirstResponder()
        
        self.searchTableView.estimatedRowHeight = 100
        self.searchTableView.rowHeight = UITableView.automaticDimension
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.commentArr = [String]()
        self.commentImageArr = [String]()
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        if let searchVideo = textField.text {
            
            let group = DispatchGroup()
 
            
            searchVideoId = searchVideo
            
            let param: Parameters = ["part":"snippet",
                                     "id":searchVideo.youtubeID ?? "",
                                     "key":"AIzaSyDaNppOEh7IXvmv-Su0WgW4HexUaUE0dvE"]
            let videosUrl = "https://www.googleapis.com/youtube/v3/videos"
            
            group.enter()
            Alamofire.request(videosUrl,
                              method: .get,
                              parameters: param,
                              encoding: URLEncoding.default)
                .responseObject { (res:DataResponse<Video>) in

                            let result = res.result.value
                            result?.items?.forEach({ (item) in
                            print(item.snippet?.description ?? "")
                                
                            self.videoDescription = item.snippet?.description
                            self.videoImageUrl = item.snippet?.thumbnails?.url
                            self.searchVideoTitle = item.snippet?.title
                                
                            group.leave()

                    })
            }
            
            
            let parameters: Parameters = ["part":"snippet",
                                          "videoId":searchVideo.youtubeID ?? "",
                                          "order":"relevance",
                                          "key":"AIzaSyDaNppOEh7IXvmv-Su0WgW4HexUaUE0dvE"]
            
            let commentThreadsUrl = "https://www.googleapis.com/youtube/v3/commentThreads"
            
            group.enter()
            Alamofire.request(commentThreadsUrl,
                              method: .get,
                              parameters: parameters,
                              encoding: URLEncoding.default)
                .responseObject { (res:DataResponse<Commnet>) in
                    let result = res.result.value
                    
                    result?.items?.forEach({ (item) in
                        self.commentArr?.append(item.snippet?.topLevelComment?.topLevelCommentSnippet?.textOriginal ?? "")
                        self.commentImageArr?.append(item.snippet?.topLevelComment?.topLevelCommentSnippet?.authorProfileImageUrl ?? "")
                        self.searchTableView.reloadData()
                    })
                    
                    group.leave()
            }
            
            group.notify(queue: DispatchQueue.main) {
                print("끝")
                self.searchComplete = true
                self.searchTableView.reloadData()
            }
 
        }
        return true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let videoDescription = videoDescription, videoDescription.count > 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
                cell.titleLabel?.text = "About...\n\n" + self.searchVideoTitle!
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDescriptionCell", for: indexPath) as! VideoDescriptionCell
                cell.descLabel?.text = videoDescription
                cell.videoImage?.sd_setImage(with: URL(string: self.videoImageUrl ?? ""), completed: nil)
                return cell
            }
        }
        
        if let commentArr = commentArr, commentArr.count > 0 {
            
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
                cell.titleLabel?.text = "Reply..."
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.commentLabel?.text = self.commentArr?[indexPath.row - 3] ?? ""
                cell.commentImage?.sd_setImage(with: URL(string: self.commentImageArr?[indexPath.row - 3] ?? ""), completed: nil)
                cell.commentImage?.layer.cornerRadius = cell.commentImage.frame.height/2
                cell.commentImage?.clipsToBounds = true
                return cell
            }
        }
        return UITableViewCell(style: .default, reuseIdentifier: "")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchComplete! {
            return searchVideoId?.count == 0 ? 0 : 3 + (commentArr?.count)!
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "", message: "선텍하신 정보를 저장하시겠습니까?", preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "저장", style: .default) { (_) in
            if let realm = try? Realm() {
                let db_comment = DB_Comment()
                db_comment.textOriginal = self.commentArr?[indexPath.row] ?? ""
                db_comment.authorProfileImageUrl = self.commentImageArr?[indexPath.row] ?? ""
                
                let db_snippet = DB_Snippet()
                db_snippet.videoId = self.searchVideoId!
                db_snippet.videoTitle = self.searchVideoTitle!
                db_snippet.videoDescription = self.videoDescription!
                db_snippet.videoThumbnail = self.videoImageUrl!
                db_snippet.comment.append(db_comment)
                
                try! realm.write {
                    realm.add(db_snippet)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        if let isPresentOK = searchComplete, isPresentOK {
            self.present(alert, animated: false, completion: nil)
        }
    }

}

class TitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class VideoDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
}

class CommentCell: UITableViewCell {
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
}



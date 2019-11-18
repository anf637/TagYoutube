//
//  SearchViewController.swift
//  TagYoutube
//
//  Created by insung on 2019/11/16.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var resultStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
//        self.searchTableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
//        self.searchTableView.register(VideoDescriptionCell.self, forCellReuseIdentifier: "VideoDescriptionCell")
        
        self.searchTableView.estimatedRowHeight = 100
        self.searchTableView.rowHeight = UITableView.automaticDimension
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchVideo = searchBar.text {
            
            let param: Parameters = ["part":"snippet",
                                     "id":searchVideo.youtubeID!,
                                     "key":"AIzaSyDaNppOEh7IXvmv-Su0WgW4HexUaUE0dvE"]
            let url = "https://www.googleapis.com/youtube/v3/videos"
            Alamofire.request(url,
                              method: .get,
                              parameters: param,
                              encoding: URLEncoding.default)
                .responseObject { (res:DataResponse<Video>) in
                    let result = res.result.value
                    result?.items?.forEach({ (item) in
                        print(item.snippet?.description ?? "")
                        self.resultStr = item.snippet?.description
                        self.searchTableView.reloadData()
                    })
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.titleLabel?.text = "About..."
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDescriptionCell", for: indexPath) as! VideoDescriptionCell
            cell.descLabel?.text = resultStr
            return cell
        }else  if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.titleLabel?.text = "Reply..."
            return cell
        }else{

        }
        return UITableViewCell(style: .default, reuseIdentifier: "")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class TitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class VideoDescriptionCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
}

class ReplyCell: UITableViewCell {
    
}

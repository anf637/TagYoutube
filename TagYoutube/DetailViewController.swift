//
//  DetailViewController.swift
//  TagYoutube
//
//  Created by 이승희 on 20/11/2019.
//

import UIKit

class DetailViewController: UIViewController {

    var detailModeSnippet: DB_Snippet?
    var commentArr:[ String]?
    var commentImageArr:[ String]?
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentArr = [String]()
        commentImageArr = [String]()
        
        self.detailTableView.estimatedRowHeight = UITableView.automaticDimension
        
        if let comment = detailModeSnippet?.comment{
            for item in comment {
                commentArr?.append(item.textOriginal)
                commentImageArr?.append(item.textOriginal)
            }
        }

    }

}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (commentArr?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
            cell.videoImage.sd_setImage(with: URL(string: (detailModeSnippet?.videoThumbnail)!), completed: nil)
            cell.titleLabel?.text = detailModeSnippet?.videoTitle
            cell.contensLabel?.text = detailModeSnippet?.videoDescription
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentTableViewCell") as! DetailCommentTableViewCell
            cell.detailCommnetImage.sd_setImage(with: URL(string: commentImageArr?[indexPath.row - 1] ?? ""), completed: nil)
            cell.detailCommentLabel.text = commentArr?[indexPath.row] ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contensLabel: UILabel!
}

class DetailCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var detailCommnetImage: UIImageView!
    @IBOutlet weak var detailCommentLabel: UILabel!
}

//
//  HighlightsViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class HighlightsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var highlightVideoWebView: WKWebView!
    @IBOutlet weak var highlightTitleLabel: UILabel!
    
}

class HighlightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var highlightsTableView: UITableView!
    
    let highlightsCellIdentifier = "Highlights Cell"
    var highlightTitles: [String] = []
    var highlightLinks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highlightsTableView.delegate = self
        highlightsTableView.dataSource = self
        fetchHighlights()
    }
    
    // Returns the number of highlights in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return highlightTitles.count
        return 1
    }
    
    // Sets the highlight title and video of each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: highlightsCellIdentifier, for: indexPath) as! HighlightsTableViewCell
        let row = indexPath.row
//        cell.highlightTitleLabel?.text = highlightTitles[row]
        cell.highlightTitleLabel?.text = "Testing"
        
        let videoHTML = "<div style=\"width: 100%; height: 0px; position: relative; padding-bottom: 56.250%;\">" +
                        "<iframe src=\"https://streamable.com/e/ndkvfn\" frameborder=\"0\" width=\"100%\" height=\"100%\"" +
                        "allowfullscreen style=\"width: 100%; height: 100%; position: absolute;\"></iframe></div>"
        cell.highlightVideoWebView.loadHTMLString(videoHTML, baseURL: nil)
        return cell
    }
    
    // Pulls NBA articles from the news API and updates the table
    func fetchHighlights() {
        // Parse this? https://www.reddit.com/search/?q=subreddit%3Anba%20site%3Astreamable.com&sort=new
        

//        AF.request(redditAPI, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                // Only parse the first 25 articles and add the data to the arrays
//                for article in 0...24 {
//                    if let title = json["articles"][article]["title"].string {
//                        self.highlightTitles.append(title)
//                    }
//                    if let url = json["articles"][article]["url"].string {
//                        self.highlightLinks.append(url)
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//            // Reload the table after the API request is compelete
//            DispatchQueue.main.async {
//                self.highlightsTableView.reloadData()
//            }
//        }
    }

}


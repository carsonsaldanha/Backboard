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
    @IBOutlet weak var highlightsActivityIndicatorView: UIActivityIndicatorView!
    
    let highlightsCellIdentifier = "Highlights Cell"
    var highlightTitles: [String] = []
    var highlightVideoIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highlightsTableView.delegate = self
        highlightsTableView.dataSource = self
        highlightsTableView.rowHeight = UITableView.automaticDimension
        highlightsTableView.estimatedRowHeight = 300
        
        highlightsActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        highlightsActivityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        highlightsActivityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        highlightsActivityIndicatorView.hidesWhenStopped = true
        highlightsActivityIndicatorView.startAnimating()
        
        fetchHighlights()
    }
    
    // Returns the number of highlights in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlightTitles.count
    }
    
    // Sets the highlight title and video of each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: highlightsCellIdentifier, for: indexPath) as! HighlightsTableViewCell
        let row = indexPath.row
        cell.highlightTitleLabel?.text = highlightTitles[row]
        let videoHTML = "<div style=\"width: 100%; height: 0px; position: relative; padding-bottom: 56.250%;" +
                        "border-radius: 23px; overflow: hidden;\">" +
                        "<iframe src=\"https://streamable.com/e/\(highlightVideoIDs[row])\" frameborder=\"0\"" +
                        "width=\"100%\" height=\"100%\" allowfullscreen style=\"width: 100%; height: 100%;" +
                        "position: absolute;\"></iframe></div>"
        cell.highlightVideoWebView.loadHTMLString(videoHTML, baseURL: nil)
        return cell
    }
    
    // Pulls NBA highlights from the reddit API and updates the table
    func fetchHighlights() {
        let redditAPI = "https://www.reddit.com/search/.json?q=subreddit%3Anba%20site%3Astreamable.com&sort=hot"
        AF.request(redditAPI, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // Only parse the first 25 highlights and add the data to the arrays
                for highlight in 0...24 {
                    if var title = json["data"]["children"][highlight]["data"]["title"].string {
                        // If the post was labeled as a "Highlight", trim the start of the title
                        if let flair = json["data"]["children"][highlight]["data"]["link_flair_text"].string,
                           flair == "Highlight" {
                            title = self.trimString(str: title, trimIndex: 12)
                        }
                        self.highlightTitles.append(title)
                    }
                    if let url = json["data"]["children"][highlight]["data"]["url"].string {
                        // Extract the video ID from the URL as a substring
                        let videoID = self.trimString(str: url, trimIndex: 23)
                        self.highlightVideoIDs.append(videoID)
                    }
                }
            case .failure(let error):
                print(error)
            }
            // Reload the table after the API request is compelete
            DispatchQueue.main.async {
                self.highlightsActivityIndicatorView.stopAnimating()
                self.highlightsTableView.reloadData()
            }
        }
    }
    
    // Helper function to trim a String from a given index to the end
    private func trimString(str: String, trimIndex: Int) -> String {
        let start = str.index(str.startIndex, offsetBy: trimIndex)
        let end = str.index(str.startIndex, offsetBy: str.count - 1)
        let range = start...end
        return String(str[range])
    }

}


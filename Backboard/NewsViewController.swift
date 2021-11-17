//
//  NewsViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articlePhotoImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
}

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let newsCellIdentifier = "News Cell"
    var articleTitles: [String] = []
    var articleImages: [String] = []
    var articleLinks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        fetchTeamArticles()
    }
    
    // Returns the number of articles in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleTitles.count
    }
    
    // Sets the article title, image, and URL of each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIdentifier, for: indexPath) as! NewsTableViewCell
        let row = indexPath.row
        cell.articleTitleLabel?.text = articleTitles[row]
        // Fetch and load the article image
        let imageUrl = URL(string: articleImages[row])!
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.articlePhotoImageView?.image = image
                    }
                }
            }
        }
        return cell
    }
    
    // Opens the link of the article in the user's browser if the cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let articleUrl = URL(string: articleLinks[row]) else { return }
        UIApplication.shared.open(articleUrl)
    }
    
    // Pulls favorite team articles from the news API and updates the table
    func fetchTeamArticles() {
        var retrievedFavoriteTeam = UserDefaults.standard.string(forKey: "favoriteTeam")
        // If the user doesn't have a favorite team, just request popular NBA articles
        if (retrievedFavoriteTeam == "None") {
            retrievedFavoriteTeam = "nba"
        }
        let newsAPI = "https://newsapi.org/v2/everything?" +
                      "q=\(retrievedFavoriteTeam!)&" +
                      "domains=espn.com,cbssports.com,nbcsports.com,nba.com,bleacherreport.com,sports.yahoo.com" +
                      "from=" + getTodaysDate() + "&" +
                      "to=" + getTodaysDate() + "&" +
                      "sortBy=popularity&" +
                      "apiKey=bd2de92e7e834d6481f1c8f279d4add0"
        AF.request(newsAPI, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // Only parse the first 5 articles and add the data to the arrays
                for article in 0...4 {
                    if let title = json["articles"][article]["title"].string {
                        self.articleTitles.append(title)
                    }
                    if let image = json["articles"][article]["urlToImage"].string {
                        self.articleImages.append(image)
                    }
                    if let url = json["articles"][article]["url"].string {
                        self.articleLinks.append(url)
                    }
                }
            case .failure(let error):
                print(error)
            }
            
            // Get general NBA articles after the API request is compelete
            DispatchQueue.main.async {
                self.fetchNBAArticles()
            }
        }
    }
    
    // Pulls NBA articles from the news API and updates the table
    func fetchNBAArticles() {
        let newsAPI = "https://newsapi.org/v2/everything?" +
                      "q=nba&" +
                      "domains=espn.com,cbssports.com,nbcsports.com,nba.com,bleacherreport.com,sports.yahoo.com" +
                      "from=" + getTodaysDate() + "&" +
                      "to=" + getTodaysDate() + "&" +
                      "sortBy=publishedAt&" +
                      "apiKey=bd2de92e7e834d6481f1c8f279d4add0"
        AF.request(newsAPI, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // Only parse the first 20 articles and add the data to the arrays
                for article in 0...19 {
                    if let title = json["articles"][article]["title"].string {
                        self.articleTitles.append(title)
                    }
                    if let image = json["articles"][article]["urlToImage"].string {
                        self.articleImages.append(image)
                    }
                    if let url = json["articles"][article]["url"].string {
                        self.articleLinks.append(url)
                    }
                }
            case .failure(let error):
                print(error)
            }
            // Reload the table after the API request is compelete
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
}

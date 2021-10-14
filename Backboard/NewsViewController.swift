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
    
    let newsCellIdentifier = "NewsCell"
    var articleTitles: [String] = []
    var articleImages: [String] = []
    var articleLinks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        fetchArticles()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIdentifier, for: indexPath) as! NewsTableViewCell
        let row = indexPath.row
        cell.articleTitleLabel?.text = articleTitles[row]
        let imageUrl = URL(string: articleImages[row])
        let data = try? Data(contentsOf: imageUrl!)
        cell.articlePhotoImageView.image = UIImage(data: data!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let articleUrl = URL(string: articleLinks[row]) else { return }
        UIApplication.shared.open(articleUrl)
    }
    
    func fetchArticles() {
        let newsAPI = "https://newsapi.org/v2/everything?" +
                  "q=NBA&" +
                  "from=2021-10-12&" + // change date
                  "sortBy=popularity&" +
                  "apiKey=bd2de92e7e834d6481f1c8f279d4add0"
        AF.request(newsAPI, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for article in 0...24 {
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
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }

}

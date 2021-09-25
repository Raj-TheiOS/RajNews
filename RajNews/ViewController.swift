//
//  ViewController.swift
//  RajNews
//
//  Created by Raj on 20/06/17.
//  Copyright © 2017 Raj. All rights reserved.
//
//2a7792c82fc24e4697c7c83a115542ec

//lstest https://newsapi.org/v2/everything?sources=techcrunch&apiKey=API_KEY

import UIKit

class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableview: UITableView!
    var source = "techcrunch"
    var articles: [Article]? = []
    let menuManager = MenuManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchArticle(fromSource: source)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleCell
        cell.lblTitle.text = self.articles?[indexPath.item].headline
        cell.lblDesc.text = self.articles?[indexPath.item].desc
        cell.lblAuthor.text = self.articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
        
    }
    func fetchArticle(fromSource provider:String){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(provider)&apiKey=2a7792c82fc24e4697c7c83a115542ec")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil {
                print(error)
                return
            }
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        // getting class instance
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    } // fetch method ending
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
}

// for image viewing from json data
extension UIImageView {
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}









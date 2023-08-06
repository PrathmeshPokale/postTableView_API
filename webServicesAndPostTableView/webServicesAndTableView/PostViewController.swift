//
//  ViewController.swift
//  webServicesAndTableView
//
//  Created by Mac on 02/08/23.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    
    private let resueIdentifireForPostTableViewCell = "PostTableViewCell"
    
    var posts : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        registerAnXIBWithTableView()
        jsonParsing()
    }
    
    func initViews(){
        postTableView.dataSource = self
        postTableView.delegate = self
    }
    
    //MARK : Regestring an XIB with tableView
    func registerAnXIBWithTableView(){
        let uiNib = UINib(nibName: resueIdentifireForPostTableViewCell, bundle: nil)
        postTableView.register(uiNib, forCellReuseIdentifier: resueIdentifireForPostTableViewCell)
    }
    
    func jsonParsing(){
        let urlString = "https://jsonplaceholder.typicode.com/comments"
        
        //MARK : converting URL string into URl
        let url = URL(string: urlString)
        
        var urlResuest = URLRequest(url: url!)
        urlResuest.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask = urlSession.dataTask(with: urlResuest){data, response, error in
            print(data)
            print(response)
            print(error)
            
            //MARK : converting json object into swift object
            
            let jsonResponse = try!  JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for eachJSONObject in jsonResponse{
                let eachPost = eachJSONObject
                let eachPostId = eachPost["postId"] as! Int
                let eachId = eachPost["id"] as! Int
                let eachName = eachPost["name"] as! String
                let eachEmail = eachPost["email"] as! String
                let eachBody = eachPost["body"] as! String
                
                //MARK : Creating Post Object
                let postObject = Post(postId:eachPostId,
                                       id: eachId,
                                       name: eachName,
                                       email: eachEmail, body: eachBody)
                
                self.posts.append(postObject)
            }
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        dataTask.resume()
    }
}
//MARK : UITableViewDataSource
extension PostViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTabelViewCell = self.postTableView.dequeueReusableCell(withIdentifier: resueIdentifireForPostTableViewCell, for: indexPath) as! PostTableViewCell
        let eachPostFetchedFromArray = posts[indexPath.row]
        postTabelViewCell.postIdLabel.text = String(eachPostFetchedFromArray.postId)
        postTabelViewCell.idLabel.text = String(eachPostFetchedFromArray.id)
        postTabelViewCell.nameLabel.text = eachPostFetchedFromArray.name
        postTabelViewCell.emailLabel.text = eachPostFetchedFromArray.email
        postTabelViewCell.bodyLabel.text = eachPostFetchedFromArray.body
        
        postTableView.separatorStyle = .singleLine
        postTableView.separatorColor = .white
        postTableView.separatorInset = .init(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
       
        return postTabelViewCell
    }
}

//MARK : UITableViewDelegate
extension PostViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.00
    }
}

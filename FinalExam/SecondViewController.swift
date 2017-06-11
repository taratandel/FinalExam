//
//  SecondViewController.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/18/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PINRemoteImage
import AVKit
import AVFoundation
import MediaPlayer
import MediaPlayer
import AVKit
import AVFoundation

let nitifkey = "notifkey"
var doreID = Int()
class Videos: NSObject {
    public var IDList:[Int] = []
    public var TitleList:[String] = []
    public var OrderBy:[Int] = []
}

class DoreRowCell : UICollectionViewCell {
    
    @IBOutlet weak var TitleOfTheMovies: UILabel!
    
    
}
class CategoryRow: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var questionNumber: UILabel!
    
    @IBOutlet weak var movieCollectionViewCell: UICollectionView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var ImageOfTheMovie: UIImageView!
    @IBOutlet weak var playerImage: UIImageView!
    
    
    
    var movieshoe = SecondViewController()
    var videosList:Videos = Videos()
    var dooreID: Int?
    var indexpa: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bckgrndimg = #imageLiteral(resourceName: "background")
        let imageview = UIImageView(image: bckgrndimg)
        movieCollectionViewCell.backgroundView = imageview
        imageview.contentMode = .scaleAspectFit
        imageview.contentMode = .scaleAspectFill
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(doThisWhenNotify),
                                               name: NSNotification.Name(rawValue: nitifkey),
                                               object: nil)
    }
    func doThisWhenNotify() {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosList.IDList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videocell", for: indexPath ) as! DoreRowCell
        
        
        let number = videosList.OrderBy[indexPath.row]
        cell.TitleOfTheMovies?.layer.cornerRadius = cell.TitleOfTheMovies.frame.width/2
        cell.TitleOfTheMovies?.layer.masksToBounds = true
        cell.TitleOfTheMovies?.layer.borderColor = UIColor.red.cgColor
        cell.TitleOfTheMovies?.layer.borderWidth = 1
        cell.TitleOfTheMovies?.text = "\(number)"
        questionNumber?.text = "شماره سوال را انتخاب کنید."
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doreID = videosList.IDList[indexPath.row];
        let imgURL = "http://www.kanoon.ir/Amoozesh/VideoFiles/\(doreID)/thumb.jpg"
        ImageOfTheMovie?.pin_setImage(from: URL(string: imgURL), completion: { (result) in
        })
        indexpa = indexPath.row
        let number = videosList.OrderBy[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name(rawValue: nitifkey), object: self)
        movieCollectionViewCell.reloadData()
        movieshoe.reloadInputViews()
    }
    
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var doreTableView: UITableView!
    var courseid = Int()
    var doreId : [Int] = []
    var dorelist : [String] = []
    var dooreList : [String] = []
    var dooreId : [Int] = []
    var blue:[Int:Videos] = [:];
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        downloadTags(){
            doreTag , doreid, error in
            if doreTag != nil{
                self.dooreList = doreTag as! [String]
                self.dooreId = doreid as! [Int]
                
                for id in doreid! {
                    
                    self.gettingData(doreha: id as! Int) { idList, titleList,orderby, _ in
                        
                        
                        let videos = Videos()
                        videos.TitleList = titleList;
                        videos.IDList = idList;
                        videos.OrderBy = orderby;
                        self.blue[id as! Int] = videos;
                        
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.doreTableView.reloadData()
                        })
                    }
                }
                
            }
            else{
            }
            
        }
        
        let bckgrndimg = #imageLiteral(resourceName: "background")
        let imageview = UIImageView(image: bckgrndimg)
        doreTableView.backgroundView = imageview
        doreTableView.tableFooterView = UIView(frame: CGRect.zero)
        imageview.contentMode = .scaleAspectFit
        imageview.contentMode = .scaleAspectFill
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoplayer),
                                               name: NSNotification.Name(rawValue: nitifkey),
                                               object: nil) }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func videoplayer (){
        let docID = doreID
        guard let url = URL(string: "http://www.kanoon.ir/Amoozesh/VideoFiles/\(docID)/playlist.m3u8") else {
            return
        }
        let player = AVPlayer(url: url)
        
        let controller = AVPlayerViewController()
        controller.player = player
        
        present(controller, animated: true) {
            player.play()
        }
    }
    
    
    
    
    func gettingData(doreha: Int, completionHandler: @escaping ([Int], [String],[Int], Error?)-> () ){
        
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/GetVideosFinal?sumcrsid=\(courseid)&tagid=\(doreha)").responseJSON{ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let jArray = json.array{
                    
                    var titleList:[String] = [];
                    var idList:[Int] = [];
                    var orderBy:[Int] = [];
                    
                    for ids in jArray{
                        if let idis = ids["DocumentId"].int{
                            if let documentTitle = ids ["FileTitle"].string{
                                let orderby = ids ["OrderBy"].int
                                idList.append(idis)
                                titleList.append(documentTitle)
                                orderBy.append(orderby!)
                                
                            }
                        }
                    }
                    
                    
                    completionHandler( idList, titleList,orderBy, nil)
                    
                }
                
            case .failure(let error):
                completionHandler([] , [],[], error)
                
                
            }
            
        }
        
    }
    
    
    func downloadTags(completionHandler: @escaping (NSArray?,NSArray?, Error?) -> ()) {
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/GetPeriodForIOS?sumcrsid=\(courseid)&groupcode=302")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let jArray = json.array{
                        for course in jArray{
                            if let cona = course["TagName"].string{
                                if let id = course["Id"].int{
                                    self.doreId.append(id)
                                    self.dorelist.append(cona)
                                    completionHandler(self.dorelist as NSArray,self.doreId as NSArray, nil)
                                }
                            }
                            
                        }
                        
                    }
                case .failure(let error):
                    completionHandler(nil,nil, error)
                }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dooreList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dorecell", for: indexPath) as! CategoryRow
        
        let id = dooreId[indexPath.section ];
        cell.dooreID = indexPath.section;
        
        if let videos = blue[id] {
            cell.videosList = videos;
            cell.header.textColor = UIColor.white
            cell.header.textAlignment = .right
            cell.header.text = dooreList[indexPath.section]
            let id = videos.IDList[0]
            let imgURL = "http://www.kanoon.ir/Amoozesh/VideoFiles/\(id)/thumb.jpg"
            
            cell.ImageOfTheMovie?.pin_setImage(from: URL(string: imgURL), completion: { (result) in
            })
            cell.playerImage?.image = #imageLiteral(resourceName: "play")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.movieCollectionViewCell.reloadData();
            cell.backgroundColor = .clear
        }
        
        return cell
    }
}

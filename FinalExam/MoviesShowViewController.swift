
//
//  MoviesShowViewController.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/21/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer
import AVKit
import AVFoundation

class MoviesShowCell : UITableViewCell{
    
    @IBOutlet weak var fixedText: UILabel!
    @IBOutlet weak var MovieTitle: UILabel!
    @IBOutlet weak var PlayerImage: UIImageView!
    
    
}

class MoviesShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var SumCrsId = Int()
    var TipID = Int()
    var tiptext : String = ""
    var fileTitle: [String] = []
    var documentID : [Int] = []
    var filesTitle: [String] = []
    var documentsID: [Int] = []
    var questionNO : String = ""
    var questionsNO : String = ""
    
    @IBOutlet weak var filetitleslabel: UITableView!
    
    @IBOutlet weak var click: UIImageView!
    
    @IBOutlet weak var TipText: UILabel!
    
    @IBAction func porTekrarQuestions(_ sender: Any) {
        performSegue(withIdentifier: "questionsNumbers", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        click.image? = #imageLiteral(resourceName: "click")
        TipText.text! = " برای مشاهده سوالات مرتبط از کتاب پرتکرار تیپ  \(tiptext)کلیک کنید"
        
        downloadFilesTitle(){
            files, ids , questionsno, error in
            if files != nil {
                self.documentsID = ids as! [Int]
                self.filesTitle = files as! [String]
                self.questionsNO = questionsno!
                self.filetitleslabel.reloadData()
            }
                
            else{
            }
        }
        
        
        let bckgrndimg = #imageLiteral(resourceName: "background")
        let imageview = UIImageView(image: bckgrndimg)
        filetitleslabel.backgroundView = imageview
        filetitleslabel.tableFooterView = UIView(frame: CGRect.zero)
        imageview.contentMode = .scaleAspectFit
        imageview.contentMode = .scaleAspectFill
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func videoplayer ( docID: Int){
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
    
    func downloadFilesTitle (completionHandler: @escaping (NSArray?, NSArray?, String?, Error?) -> ()){
        
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/GetVideoTips?sumcrsid=\(SumCrsId)&tipid=\(TipID)").responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let jsonArray = json.array{
                    for ids in jsonArray {
                        if let filetitle = ids["FileTitle"].string{
                            if let documentid = ids["DocumentId"].int
                            {
                                self.fileTitle.append(filetitle)
                                self.documentID.append(documentid)
                                let questionsno = ids["Questions"].string
                                self.questionNO = questionsno!
                                completionHandler(self.fileTitle as NSArray? , self.documentID as NSArray? , self.questionNO as String?, nil)
                            }
                        }
                    }
                }
            case .failure(let error):
                completionHandler(nil, nil, nil, error)
            }
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filesTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieshow", for: indexPath) as! MoviesShowCell
        let cellname = filesTitle[indexPath.row]
        cell.fixedText?.text = cellname
        cell.MovieTitle.layer.borderColor = UIColor.red.cgColor
        cell.MovieTitle.layer.borderWidth = 3
        cell.PlayerImage?.image = #imageLiteral(resourceName: "whiteplayer")
        cell.MovieTitle?.layer.cornerRadius = 5
        cell.MovieTitle?.clipsToBounds = true
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        videoplayer(docID: documentsID[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionsNumbers"{
            let questionsNOCollectionView = segue.destination as! PorTekrarQuestionsViewController
            questionsNOCollectionView.questionno = questionsNO
            questionsNOCollectionView.sumCrsIds = SumCrsId
            questionsNOCollectionView.TipIDs = TipID
            
        }
    }
    
}

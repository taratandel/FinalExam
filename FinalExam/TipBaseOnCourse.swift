//
//  File.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/20/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class TipsComstumizedCell : UITableViewCell{
    
    @IBOutlet weak var RedSquare: UIImageView!
    @IBOutlet weak var WhiteCircle: UIImageView!
    
    @IBOutlet weak var NameOfTip: UILabel!
    @IBOutlet weak var MoviesNO: UILabel!
}
class TipBaseOnCourse :  UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tipID = Int()
    var tipsid : [Int] = []
    var tipsname: [String] = []
    var documentscount: [Int] = []
    var tipsId : [Int] = []
    var tipsName: [String] = []
    var documentsCount: [Int] = []
    var valueToPass = Int()
    var textt : String = ""
    @IBOutlet weak var TipTable: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        downloadTips(){
            tipid, tipname, doccount, error in
            if (tipname != nil) && (tipid != nil) && (doccount != nil){
                self.tipsId = tipid as!  [Int]
                self.tipsName = tipname as! [String]
                self.documentsCount = doccount as! [Int]
                self.TipTable.reloadData()
                
            }
            else{
            }
        }
        
        let bckgrndimg = #imageLiteral(resourceName: "background")
        let imageview = UIImageView(image: bckgrndimg)
        self.TipTable.backgroundView = imageview
        TipTable.tableFooterView = UIView(frame: CGRect.zero)
        imageview.contentMode = .scaleAspectFit
        imageview.contentMode = .scaleAspectFill
        
    }
    
    
    
    func downloadTips (completionHandler: @escaping (NSArray?, NSArray?, NSArray?, Error?)-> ()){
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/GetTips?sumcrsid=\(tipID)").responseJSON {response in
            switch response.result{
            case .success (let value):
                let json = JSON(value)
                if let jArray = json.array{
                    for documents in jArray{
                        if let documentCount = documents["DocumentCount"].int{
                            if let tipid = documents["TipId"].int{
                                if let tipname = documents["TipName"].string{
                                    self.tipsid.append(tipid)
                                    self.tipsname.append(tipname)
                                    self.documentscount.append(documentCount)
                                    completionHandler(self.tipsid as NSArray, self.tipsname as NSArray, self.documentscount as NSArray, nil)
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
            case .failure (let error):
                completionHandler (nil, nil, nil, error)
                
                
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tipsId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipsComstumizedCell", for: indexPath) as! TipsComstumizedCell
        cell.MoviesNO.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.MoviesNO.numberOfLines = 3
        let cellname = tipsname[indexPath.row]
        let cellsidename = documentscount[indexPath.row]
        cell.MoviesNO?.text = cellname
        cell.NameOfTip?.text = " \(cellsidename) فیلم"
        cell.RedSquare?.image = #imageLiteral(resourceName: "qwerty")
        cell.WhiteCircle?.image = #imageLiteral(resourceName: "white")
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueToPass = tipsId [
            indexPath.row]
        textt = tipsname[indexPath.row]
        self.performSegue(withIdentifier: "MovieView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieView" {
            let movieshow = segue.destination as! MoviesShowViewController
            movieshow.TipID = valueToPass
            movieshow.SumCrsId = tipID
            movieshow.tiptext  = textt
        }
    }
}

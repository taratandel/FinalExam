//
//  CourseListTableViewController.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/16/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import CoreData

class CourseTipTableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var RedSquare: UIImageView!
    @IBOutlet weak var courseText: UILabel!
}
class porTekrar: UITableViewController {
    var Courses:[String] = []
    var row = Int()
    var coursss : [String] = []
    var idc : [Int] = []
    var idcc : [Int] = []
    var valueToPass : Int!
    var ID: Int!
    var loginCheck: [NSManagedObject] = []
    
    
    @IBOutlet var courseList: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shomarande")
        
        do {
            loginCheck = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        downloadTags(){
            coursename , id, error in
            
            if coursename != nil{
                self.coursss = coursename as! [String]
                self.idcc = id as! [Int]
                self.courseList.reloadData()
                
            }
            else{ }
            
        }
        
        let bckgrndimg = #imageLiteral(resourceName: "background")
        let imageview = UIImageView(image: bckgrndimg)
        self.tableView.backgroundView = imageview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        imageview.contentMode = .scaleAspectFit
        imageview.contentMode = .scaleAspectFill
    }
    
    func downloadTags(completionHandler: @escaping (NSArray?,NSArray?, Error?) -> ()) {
        if let IDs: Int = ID{
            Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/GetCrsFinal?groupcode=\(IDs)")
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        if let jArray = json.array{
                            for course in jArray{
                                if let cona = course["CrsName"].string{
                                    if let id = course["SumCrsId"].int{
                                        self.idc.append(id)
                                        self.Courses.append(cona)
                                        completionHandler(self.Courses as NSArray,self.idc as NSArray, nil)
                                    }
                                }
                                
                            }
                            
                        }
                    case .failure(let error):
                        completionHandler(nil,nil, error)
                    }
            }
        }
        else {
            let IDs = loginCheck[0]
            if let IDss: Int = IDs.value(forKey: "shomare") as? Int{
                
                Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/GetCrsFinal?groupcode=\(IDss)")
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            if let jArray = json.array{
                                for course in jArray{
                                    if let cona = course["CrsName"].string{
                                        if let id = course["SumCrsId"].int{
                                            self.idc.append(id)
                                            self.Courses.append(cona)
                                            completionHandler(self.Courses as NSArray,self.idc as NSArray, nil)
                                        }
                                    }
                                    
                                }
                                
                            }
                        case .failure(let error):
                            completionHandler(nil,nil, error)
                        }
                }
                
                
            }
                
            else{
                
                return
                
            }

        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coursss.count 
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesTip", for: indexPath) as! CourseTipTableViewCell
        let cellname = coursss[indexPath.row]
        cell.courseText?.text = cellname
        cell.RedSquare?.image = #imageLiteral(resourceName: "qwerty")
        cell.backgroundColor = .clear
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        row = indexPath.row
        self.performSegue(withIdentifier: "tipsList", sender: self)
        
        
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tipsList"{
            let secondViewController = segue.destination as! TipBaseOnCourse
            valueToPass = idcc[row]
            secondViewController.tipID = valueToPass
            
        }
    }}

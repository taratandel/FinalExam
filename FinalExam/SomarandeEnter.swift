//
//  SomarandeEnter.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/12/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


class SomarandeEnter: UIViewController{
    
    @IBOutlet var Enter: UIButton!
    @IBOutlet weak var shomarandeNO: UITextField!
    
    @IBOutlet weak var backgrnd: UIImageView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var hats: UIImageView!
    var gpcode: Int?
    var isLogeIn : [NSManagedObject] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var frames = CGRect()
        frames = shomarandeNO.frame
        frames.size.height = 65
        shomarandeNO.frame = frames
        shomarandeNO.becomeFirstResponder()
        backgrnd?.image = #imageLiteral(resourceName: "background")
        hats?.image = #imageLiteral(resourceName: "hats")
        
        let  soolati = UIColor(red:0.88, green:0.19, blue:0.45, alpha:1.0)
        
        Enter.layer.shadowRadius = 3
        Enter.layer.shadowColor = soolati.cgColor
        Enter.layer.shadowOffset = CGSize(width : 2, height : 2)
        Enter.layer.shadowOpacity = 1
        Enter.layer.masksToBounds = false
        
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func Enter(_ sender: UIButton) {
        let shomarandes = shomarandeNO.text!
        self.confirm(shomarande: shomarandes){
            groupcode, error in
            
            self.gpcode = groupcode
            if self.gpcode != nil {
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                // 2
                let entity =
                    NSEntityDescription.entity(forEntityName: "Shomarande",
                                               in: managedContext)!
                
                let person = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
                
                
                person.setValue(self.gpcode, forKeyPath: "shomare")
                
                // 4
                do {
                    try managedContext.save()
                    self.isLogeIn.append(person)
                    self.performSegue(withIdentifier: "validStd", sender: self)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }

            
        }

        
    }
    
    func confirm(shomarande:String!, completionHandler: @escaping (Int?, Error?) ->()){
        let shomarande = shomarandeNO.text!
        let urlString = "http://www.kanoon.ir/Amoozesh/api/Document/GetKanoonStudent?counter=\(shomarande)&password=kanoon!@123"
        
        Alamofire.request(urlString).responseJSON { response in
            if NetworkReachabilityManager()!.isReachable{
                if let res : NSDictionary? = response.result.value as? NSDictionary{
                    
                    if ((res?["Message"]) != nil) {
                        self.info.text = "شمارنده اشتباه است!"
                        self.info.textColor = UIColor.red
                    }
                        
                    else{
                        if let JSON = response.result.value {
                            let gpid = JSON as? NSDictionary
                            let groupid: Int! = gpid!["GroupCode"] as! Int
                            completionHandler(groupid, nil)
                           // self.performSegue(withIdentifier: "validStd", sender: nil);
                            
                        }
                        
                    }
                }
            }
                
            else{
                self.info.text = "اینترنت خود را بررسی کنید"
                self.info.textColor = UIColor.blue
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "validStd"{
            let tabBarC = segue.destination as! UITabBarController
            let firstview = tabBarC.viewControllers?[1] as! porTekrar
            let secondview = tabBarC.viewControllers?[0] as! CourseListTableViewController
            firstview.ID = gpcode
            secondview.ID = gpcode
        }
        
    }
}

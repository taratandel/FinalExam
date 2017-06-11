//
//  BedooneShomarande.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/15/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


class BedooneShomarande: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var Picker: UIPickerView!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var backgrn: UIImageView!
    @IBOutlet weak var people: UIImageView!
    @IBOutlet weak var warning: UILabel!
    var isLogIn: [NSManagedObject] = []
    
    var codereshte = 0
    
    
    var reshteSelect : Int = 0
    
    var courses = [" ریاضی فیزیک","علوم تجربی","علوم انسانی"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reshteSelect = row
    }
    let  soolati = UIColor(red:0.88, green:0.19, blue:0.45, alpha:1.0)
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: courses[row], attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)])
        return attributedString
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backgrn?.image = #imageLiteral(resourceName: "background")
        var frames = CGRect()
        frames = phone.frame
        frames.size.height = 65
        phone.frame = frames
        var framess = CGRect()
        framess.size.height = 65
        
        people?.image = #imageLiteral(resourceName: "peopl")
        
        Picker.delegate = self
        Picker.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func downloadTags(phoneNumber: Int, reshtecode: Int,completionHandler: @escaping (String? , Error?) -> ()) {
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/SendActivationCode?m=\(phoneNumber)&g=\(reshtecode)")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let res: String = value as? String
                    {
                        completionHandler(res, nil)
                    }
                    
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
        
    }
    func getanswer(phoneNumber: Int, EnterCode: Int,completionHandler: @escaping (Int? , Error?) -> ()) {
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/CheckActivationKey?m=\(phoneNumber)&key=\(EnterCode)")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let res: Int = value as? Int
                    {
                        completionHandler(res, nil)
                    }
                    
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
        
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        guard let phones = Int(phone.text!)
            else{
                warning.text = "لطفا اطلاعات را کامل وارد کنید"
                return
                
        }
        
        if reshteSelect==0 {
            codereshte=21
        }else if reshteSelect==1{
            codereshte=22
        }else if reshteSelect==2{
            codereshte=23
        }
        
        
        var answers: String?
        
        
        if phones != 0{
            self.downloadTags(phoneNumber: phones, reshtecode:codereshte
            ){answer, error in
                answers = answer
                if answers == "ok"{
                    
                    let alertController = UIAlertController(title: "ورود کد", message: "", preferredStyle: .alert)
                    
                    let saveAction = UIAlertAction(title: "ارسال دوباره", style: .default, handler: {
                        alert -> Void in
                        
                        self.downloadTags(phoneNumber: phones, reshtecode: self.codereshte
                        ){answer, error in
                            answers = answer
                        }
                        self.present(alertController, animated: true, completion: nil)
                    })
                    
                    let cancelAction = UIAlertAction(title: "تایید", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                        let firstTextField = alertController.textFields![0] as UITextField
                        if firstTextField.text != ""{
                            self.getanswer(phoneNumber: phones, EnterCode: Int(firstTextField.text!)!){ res , error in
                                if res == 1{
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
                                    
                                    
                                    person.setValue(self.codereshte, forKeyPath: "shomare")
                                    
                                    // 4
                                    do {
                                        try managedContext.save()
                                        self.isLogIn.append(person)
                                        self.performSegue(withIdentifier: "goToTabBar", sender: self)
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                    

                                    
                                }
                                    
                                else{
                                    
                                    self.warning.text = "کد ارسالی صحیح نیست"
                                }
                            }
                        }
                        
                    })
                    
                    alertController.addTextField { (textField : UITextField!) -> Void in
                        textField.placeholder = "کد ارسال شده را وارد کنید"
                    }
                    
                    alertController.addAction(saveAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else{
                    self.warning.text = "اطلاعات صحیح نیست"
                }
            }
            
        }
        else {
            warning.text = "لطفا اطلاعات را کامل وارد کنید"
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTabBar"{
            let tabBarC = segue.destination as! UITabBarController
            let firstview = tabBarC.viewControllers?[1] as! porTekrar
            let secondview = tabBarC.viewControllers?[0] as! CourseListTableViewController
            firstview.ID = self.codereshte
            secondview.ID = self.codereshte
            
        }
        
        
    }
    
}

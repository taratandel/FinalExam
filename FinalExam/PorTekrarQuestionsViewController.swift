//
//  PorTekrarQuestionsViewController.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/21/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer



class PorTekrarQuestion: UICollectionViewCell {
    
    @IBOutlet weak var numbers: UILabel!
}


class PorTekrarQuestionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var backgrn: UIImageView!
    
    var questionno : String = ""
    var sumCrsIds = Int()
    var TipIDs = Int()
    var fullNameArr: [String] = []
    
    @IBOutlet weak var questions: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameArr = questionno.components(separatedBy: ",")
        questions.reloadData()
        backgrn?.image = #imageLiteral(resourceName: "background")
        questions?.backgroundColor = .clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullNameArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->UICollectionViewCell
    {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "porTekrarQuestions", for: indexPath as IndexPath) as! PorTekrarQuestion
        cell.numbers?.layer.cornerRadius = cell.numbers.frame.width/2
        cell.numbers?.layer.masksToBounds = true
        cell.numbers?.layer.borderColor = UIColor.red.cgColor
        cell.numbers?.layer.borderWidth = 1
        cell.numbers?.text = fullNameArr[indexPath.row]
        cell.backgroundColor? = .clear
        return cell
    }
    
}

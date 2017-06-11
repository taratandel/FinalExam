//
//  ViewController.swift
//  FinalExam
//
//  Created by Tara Tandel on 2/15/1396 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit





class ViewController: UIViewController {
    
    @IBOutlet weak var people: UIImageView!
    @IBOutlet weak var hat: UIImageView!
    @IBOutlet weak var backgrounf: UIImageView!
   
    
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
        
        let  whites = UIColor(red:255, green:255, blue:255, alpha:1.0)
        
        kanooniEnter.layer.shadowRadius = 3
        kanooniEnter.layer.shadowColor = whites.cgColor
        kanooniEnter.layer.shadowOffset = CGSize(width : 2, height : 2)
        kanooniEnter.layer.shadowOpacity = 2
        kanooniEnter.layer.masksToBounds = false
        kanooniEnter.layer.cornerRadius = 5
        
        
        notKanooniEnter.layer.shadowRadius = 3
        notKanooniEnter.layer.shadowColor = whites.cgColor
        notKanooniEnter.layer.shadowOffset = CGSize(width : 2, height : 2)
        notKanooniEnter.layer.shadowOpacity = 2
        notKanooniEnter.layer.masksToBounds = false
        notKanooniEnter.layer.cornerRadius = 5
        backgrounf?.image = #imageLiteral(resourceName: "background")
        
        hat?.image = #imageLiteral(resourceName: "hats")
        people?.image = #imageLiteral(resourceName: "peopl")
    }
    
    @IBOutlet weak var kanoon: UIImageView!
    @IBOutlet var kanooniEnter: UIButton!
    
    @IBOutlet var notKanooniEnter: UIButton!
    
    @IBOutlet weak var blooms: UIImageView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

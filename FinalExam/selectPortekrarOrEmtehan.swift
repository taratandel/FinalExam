//
//  selectPortekrarOrEmtehan.swift
//  FinalExam
//
//  Created by negar on 96/Ordibehesht/18 AP.
//  Copyright © 1396 Tara Tandel. All rights reserved.
//

import UIKit

class selectPortekrarOrEmtehan: UIViewController {
    
    @IBOutlet var emtehan: UIButton!
    @IBOutlet var porTekrar: UIButton!
    
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
        
        
        let  soolati = UIColor(red:0.88, green:0.19, blue:0.45, alpha:1.0)
        
        porTekrar.layer.shadowRadius = 3
        porTekrar.layer.shadowColor = soolati.cgColor
        porTekrar.layer.shadowOffset = CGSize(width : 2, height : 2)
        porTekrar.layer.shadowOpacity = 1
        porTekrar.layer.masksToBounds = false
        
        emtehan.layer.shadowRadius = 3
        emtehan.layer.shadowColor = soolati.cgColor
        emtehan.layer.shadowOffset = CGSize(width : 2, height : 2)
        emtehan.layer.shadowOpacity = 1
        emtehan.layer.masksToBounds = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//
//  ViewController.swift
//  Unticket
//
//  Created by Graphic on 2021-05-16.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    let db=Firestore.firestore()

    @IBOutlet weak var appIcon: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appIcon?.image=UIImage(named: "appicon")
        
    }


}


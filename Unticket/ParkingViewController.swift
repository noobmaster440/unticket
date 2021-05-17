//
//  ParkingViewController.swift
//  Unticket
//
//  Created by Graphic on 2021-05-16.
//

import UIKit

class ParkingViewController: UIViewController {

    @IBOutlet weak var time: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        time.dataSource = self
//        time.delegate = self
        // Do any additional setup after loading the view.
    }
    

}

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5;
    }
    
    
}
extension ViewController:  UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "test"
    }
}

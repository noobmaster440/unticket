
import UIKit
import MapKit
class ParkingViewController: UIViewController {

    @IBOutlet weak var time: UIPickerView!
    @IBOutlet weak var buildingCode: UIPickerView!
    @IBOutlet weak var timestamp: UITextField!
    @IBOutlet weak var suitNo: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var mapLocation: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.time.dataSource = self
//        self.time.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addParking(_ sender: Any) {
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

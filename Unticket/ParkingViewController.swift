
import UIKit
import MapKit
class ParkingViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return arrayOf24.count
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
       {
               return String(arrayOf24[row])
           
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
           //let hourValue = arrayOf24[time.selectedRow(inComponent: 0)]
           //let minutelValue = arrayOf60[time.selectedRow(inComponent: 1)]
           
               print(String(arrayOf24[row]))
       }
    var arrayOf24 = Array(0...24)
    var arrayOf60 = Array(0...60)
    @IBOutlet weak var time: UIPickerView!
    
    @IBOutlet weak var timestamp: UITextField!
    @IBOutlet weak var suitNo: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var LicenseplateNo: UITextField!
    
    @IBOutlet weak var buildingCode: UITextField!
    
    @IBOutlet weak var mapLocation: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        time.delegate = self
        time.delegate?.pickerView?(time, didSelectRow: 0, inComponent: 0)
              
    }
    
    @IBAction func addParking(_ sender: Any) {
    }
    
}



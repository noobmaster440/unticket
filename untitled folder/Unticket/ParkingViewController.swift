
import UIKit
import MapKit
import FirebaseFirestore
class ParkingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var hoursOption: [String] = [String]()
    var noOfHours=""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hoursOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hoursOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        noOfHours=hoursOption[row]
    }
    
    
    let db=Firestore.firestore()
    
    @IBOutlet weak var tsuitNo: UITextField!
    @IBOutlet weak var tnoOfHours: UIPickerView!
    @IBOutlet weak var tcarPlate: UITextField!
    @IBOutlet weak var tbuildingNo: UITextField!
    @IBOutlet weak var ttimestamp: UITextField!
    @IBOutlet weak var tmapLocation: MKMapView!
    @IBOutlet weak var taddress: UITextField!
    
    
    @IBAction func addParking(_ sender: Any) {
        
        let timestamp=ttimestamp.text!
        let suitNo=tsuitNo.text!
        let address=taddress.text!
        let carPlate=tcarPlate.text!
        let buildingNo=tbuildingNo.text!
        
        
        
        //optional, but helpful
        if (timestamp.isEmpty || address.isEmpty || carPlate.isEmpty || suitNo.isEmpty || buildingNo.isEmpty || noOfHours.isEmpty) {
            print("You must enter all the information")
            let alert = UIAlertController(title: "You must enter all the information", message: "Make sure you don't leave any textbox empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Try", comment: "default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //  2. add it to firebase
        let parking = [
            "timestamp":timestamp,
            "password":suitNo,
            "address":address,
            "carPlate":carPlate,
            "suitNo":suitNo,
            "buildingNo":buildingNo,
            "noOfHours":noOfHours
        ]
        
        db.collection("parking").addDocument(data: parking) { (error) in
            if let err = error {
                print("Error when saving document")
                print(err)
                return
            }
            else {
                print("document saved successfully")
                self.ttimestamp.text=""
                self.tsuitNo.text=""
                self.taddress.text=""
                self.tcarPlate.text=""
                self.tsuitNo.text=""
                self.tbuildingNo.text=""
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tnoOfHours.dataSource = self
        self.tnoOfHours.delegate = self
        
        hoursOption=["1-hour or less", "4-hour", "12-hour", "24-hour"]
    }
}
//
//
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


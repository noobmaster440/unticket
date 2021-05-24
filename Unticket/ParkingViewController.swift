
import UIKit
import MapKit

import CoreLocation
import FirebaseFirestore

class ParkingViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate{
    
    private let geocoder = CLGeocoder()
    let db=Firestore.firestore()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrayOf24.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(arrayOf24Titles[row])
    }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        numberOfHours = arrayOf24[row]
           
           //let hourValue = arrayOf24[time.selectedRow(inComponent: 0)]
           //let minutelValue = arrayOf60[time.selectedRow(inComponent: 1)]
           
        print(String(arrayOf24[row]))
        
    }
    var arrayOf24 =  [1,4,12,24]
    var arrayOf24Titles = ["1 Hr or less", "4 Hr", "12 Hr", "24 Hr"]
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var time: UIPickerView!
    
    @IBOutlet weak var timestamp: UITextField!
    @IBOutlet weak var suitNo: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var LicenseplateNo: UITextField!
    
    @IBOutlet weak var buildingCode: UITextField!
    
    
    @IBOutlet weak var mapView: MKMapView!
    

    @IBOutlet weak var txtCountryName: UITextField!
    @IBOutlet weak var txtCityName: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    
    var streetName = ""
    var cityName = ""
    var countryName = ""
    var latitude = 0.0;
    var longitude = 0.0;
    var numberOfHours = 1;
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print(#function, "Location access granted")
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
        }else{
            print(#function, "Location access denied")
        }
        
    }
    
    
    @IBOutlet weak var mapLocation: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        time.delegate = self
        time.delegate?.pickerView?(time, didSelectRow: 0, inComponent: 0)
              
    }
    
    private func getLocation(address : String){
        self.geocoder.geocodeAddressString(address, completionHandler: { (placemark, error) in
            self.processGeoResponse(placemarks: placemark, error: error)
        })
    }
    
    private func processGeoResponse(placemarks: [CLPlacemark]?, error: Error?){
        if error != nil{
            self.errorText.text = "Unable to get location coordinates"
        }else{
            var obtainedLocation : CLLocation?
            
            if let placemark = placemarks, placemarks!.count > 0{
                obtainedLocation = placemark.first?.location
            }
            
            if obtainedLocation != nil{
                
                latitude = obtainedLocation?.coordinate.latitude ?? 0.0
                longitude = obtainedLocation?.coordinate.longitude ?? 0.0
                
                print("latitude \(latitude)")
                print("longitude \(longitude)")
                self.errorText.text = "Location details verified"
                
            }else{
                self.errorText.text = "No Coordinates Found"
            }
        }
    }
    
    
    @IBAction func getLocationPressed(_ sender: Any) {
        guard let country = txtCountryName.text else {return}
        guard let city = txtCityName.text else {return}
        guard let street = address.text else {return}
                
        streetName = street
        countryName = country
        cityName = city
            
        let postalAddress = "\(country), \(city), \(street)"
        print("Postal Address \(postalAddress)")
                
        self.getLocation(address: postalAddress)
    }
    
    @IBAction func addParking(_ sender: Any) {
        
        self.errorText.text = ""
        
        var date_time = getTimestamp()
        
        if(streetName.isEmpty)
        {
            errorText.text = "Street Name is empty"
            return
        }
        
        print("latitude \(latitude)")
        print("longitude \(longitude)")
        
        if(latitude == 0.0 || longitude == 0.0)
        {
            errorText.text = "Can not get Location details"
            return
        }
        guard let buildingCodeString = buildingCode.text else {
            errorText.text  = "Unknown Error"
            return
        }
        if( buildingCodeString.count != 5 )
        {
            errorText.text = "Building must be 5 letter"
            return
        }
        
        guard let licenseStr = LicenseplateNo.text else {
            errorText.text  = "Unknown Error"
            return
        }
        if( !(licenseStr.count >= 2 && licenseStr.count <= 8 ))
        {
            errorText.text = "Please Give Valid License Number"
            return
        }
        
        guard let suitStr = suitNo.text else {
            errorText.text  = "Unknown Error"
            return
        }
        if(!( suitStr.count >= 2 && suitStr.count <= 5) )
        {
            errorText.text = "Please Give Valid Suit Number"
            return
        }
        
        if(suitStr.isEmpty || licenseStr.isEmpty || buildingCodeString.isEmpty || streetName.isEmpty)
        {
            errorText.text = "Please Give All details"
            return
        }
        
        let parkingDetails = [
            "building_code":buildingCodeString,
            "no_hours":numberOfHours,
            "license":licenseStr,
            "suit_number":suitStr,
            "street":streetName,
            "latitude":latitude,
            "longitude":longitude,
            "date_time":date_time
        ] as [String : Any]
        
        db.collection("parking").addDocument(data: parkingDetails) { (error) in
            if let err = error {
                print("Error when saving document")
                print(err)
                return
            }
            else {
                print("document saved successfully")
                self.LicenseplateNo.text = ""
                self.buildingCode.text = ""
                self.suitNo.text = ""
                self.address.text = ""
                self.errorText.text = ""
                
            }
        }
    }
    
    func getTimestamp() -> String {
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        return timestamp
    }
    
}

extension ParkingViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //fetch the device location
        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
            return
        }
        
        print(#function, "Current Location : lat \(currentLocation.latitude) lng \(currentLocation.longitude)")
           
        guard let lat = Double(String(currentLocation.latitude)) else{
            return
        }
        
        guard let lng = Double(String(currentLocation.longitude)) else{
            return
        }
        
        latitude = lat
        longitude = lng
        
        self.getAddress(location: CLLocation(latitude: lat, longitude: lng))
        
        self.displayLocationOnMap(location: currentLocation)
    }
    
    func getAddress(location : CLLocation){
            self.geocoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
                self.processGeoResponse(placemarkList: placemark, error: error)
            })
        }
        
        func processGeoResponse(placemarkList : [CLPlacemark]?, error: Error?){
            if error != nil{
                self.address.text = "Unable to get address"
            }else{
                if let placemarks = placemarkList, let placemark = placemarks.first{
                    
                    let city = placemark.locality ?? "NA"
                    //let province = placemark.administrativeArea ?? "NA"
                    let country = placemark.country ?? "NA"
                    let street = placemark.thoroughfare ?? "NA"
                    
                    self.address.text = "\(street)"
                    self.txtCityName.text = "\(city)"
                    self.txtCountryName.text = "\(country)"
                    streetName = "\(street)"
                    
                }else{
                    self.address.text = "No Address Found"
                }
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Unable to get location \(error)")
    }
    
    func displayLocationOnMap(location : CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView?.setRegion(region, animated: true)
        
        //display annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "You'r here"
        self.mapView?.addAnnotation(annotation)
    }
}




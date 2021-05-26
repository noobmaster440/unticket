//
//  ParkingDetailViewController.swift
//  Unticket
//
//  Created by Graphic on 2021-05-25.
//

import UIKit
import MapKit
class ParkingDetailViewController: UIViewController , MKMapViewDelegate{
    let locationManager = CLLocationManager()
    var currentLocation2 : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:37.7749 , longitude: -122.4194)
   
    
    @IBOutlet weak var mapdirection: MKMapView!
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var streetName: UITextField!
    @IBOutlet weak var suitNo: UITextField!
    @IBOutlet weak var licensePlate: UITextField!
//    @IBOutlet weak var numberofHours: UITextField!
    @IBOutlet weak var buildingCode: UITextField!
    
    @IBOutlet weak var numberOfHours: UILabel!
    
    var sourceLocation = CLLocationCoordinate2D(latitude:39.173209 , longitude: -94.593933)
    var destinationLocation = CLLocationCoordinate2D(latitude:38.643172 , longitude: -90.177429)
    
    var finalList:[parking]=[]
    var index:IndexPath=[0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("reached sweden")
        streetName.text=finalList[index.row].street
        print(finalList[index.row].no_hours)
        print(finalList[index.row].date_time)
        //        country.text=finalList[index.row].country
        //        city.text=finalList[index.row].city
        suitNo.text=finalList[index.row].suit_number
        licensePlate.text=finalList[index.row].license
        
        buildingCode.text=finalList[index.row].building_code
        numberOfHours.text=String(finalList[index.row].no_hours)
        date.text=String(finalList[index.row].date_time)
    }
    @IBAction func getDirection(_ sender: Any) {
    
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print(#function, "Location access granted")
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
            sourceLocation = CLLocationCoordinate2D(latitude:currentLocation2.latitude , longitude:currentLocation2.longitude)
            destinationLocation = CLLocationCoordinate2D(latitude:finalList[index.row].latitude , longitude: finalList[index.row].longitude)
            
            let sourcePin = customPin(pinTitle: "Current Location", pinSubTitle: "", location: sourceLocation)
            let destinationPin = customPin(pinTitle: "Parking Location", pinSubTitle: "", location: destinationLocation)
            self.mapdirection.addAnnotation(sourcePin)
            self.mapdirection.addAnnotation(destinationPin)
            
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResonse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
                
                //get route and assign to our route variable
                let route = directionResonse.routes[0]
                
                //add rout to our mapview
                self.mapdirection.addOverlay(route.polyline, level: .aboveRoads)
                
                //setting rect of our mapview to fit the two locations
                let rect = route.polyline.boundingMapRect
                self.mapdirection.setRegion(MKCoordinateRegion(rect), animated: true)
                self.mapdirection.delegate = self
            }
            
            
        }else{
            print(#function, "Location access denied")
        }
    }
    func mapdirection(_ mapdirection: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 7.0
        return renderer
    }
}
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
extension ParkingDetailViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //fetch the device location
        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
            return
        }
        currentLocation2=currentLocation
        print(#function, "Current Location : lat \(currentLocation.latitude) lng \(currentLocation.longitude)")
        
        sourceLocation = CLLocationCoordinate2D(latitude:currentLocation.latitude , longitude:currentLocation.longitude)
        destinationLocation = CLLocationCoordinate2D(latitude:finalList[index.row].latitude , longitude: finalList[index.row].longitude)
        
        //        self.displayLocationOnMap(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Unable to get location \(error)")
    }
    
}

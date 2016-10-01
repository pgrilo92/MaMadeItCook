import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var slide2: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let camera = GMSCameraPosition.camera(withLatitude: 41.887,
            longitude:-87.622, zoom:15)
        
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = (camera?.target)!
        marker.snippet = "Ma Made It"
        // marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        marker.icon = UIImage(named: "Mahead.png")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        slide2.target = self.revealViewController()
        slide2.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
}
// MARK: - CLLocationManagerDelegate
//1
extension MapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines as! [String]
                self.addressLabel.text = lines.joined(separator: "\n")
                
                // 4
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                    
                    
                    
                }) 
            }
        }
    }
    
    /*  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    // 1
    mapView.clear()
    // 2
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
    for place: GooglePlace in places {
    // 3
    let marker = PlaceMarker(place: place)
    // 4
    marker.map = self.mapView
    }
    }
    }*/
    
}
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView!, idleAt position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
    
    /* func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
    // 1
    let placeMarker = marker as! PlaceMarker
    
    // 2
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
    // 3
    infoView.nameLabel.text = placeMarker.place.name
    
    // 4
    if let photo = placeMarker.place.photo {
    infoView.placePhoto.image = photo
    } else {
    infoView.placePhoto.image = UIImage(named: "generic")
    }
    
    return infoView
    } else {
    return nil
    }
    }
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
    }*/
    
}

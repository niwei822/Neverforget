//
//  MapViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/21/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    @IBOutlet var map: MKMapView!
    //give access to location manager
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle responses asynchronously
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestAlwaysAuthorization()
        // triggers the location permission dialog
        //locationManager.requestWhenInUseAuthorization()
        //get current location update and call delegate didUpdateLocations
        locationManager.startUpdatingLocation()
        map.delegate = self
        //locationsearchtable serve as the searchResultsUpdater delegate
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        //configures the search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.searchTextField.font = UIFont(name: "Deysia Brush", size: 15)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for stores:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation  = true
        definesPresentationContext = true
        //passes along a handle of the mapView
        locationSearchTable.mapView = map
        locationSearchTable.handleMapSearchDelegate = self
    }
    //get an array of locations
    //Zoom to the user’s current location
    //Tells the delegate that new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //print(location)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            map.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let number = placemark.subThoroughfare,
           let street = placemark.thoroughfare,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(number) \(street),\(city), \(state)"
        }
        //To initialize the bubble.
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}

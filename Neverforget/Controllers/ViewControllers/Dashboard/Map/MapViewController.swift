//
//  MapViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/21/22.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.searchTextField.font = UIFont(name: "Deysia Brush", size: 15)
        searchBar.placeholder = "Search for stores"
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation  = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = map
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
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
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
    }
}


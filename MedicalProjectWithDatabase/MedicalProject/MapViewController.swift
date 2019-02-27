//
//  MapViewController.swift
//  MedicalProject
//
//

import UIKit
import CoreLocation
import FirebaseDatabase
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
  
    @IBOutlet weak var mapView: MKMapView!
    
    var customerInfo: DatabaseReference!
    
    
    
    let regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayAnnotations()
        
        let initialLocation = CLLocation(latitude: 36.125499498, longitude: -95.935662924)
        
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
            
}
    
    
    
    func displayAnnotations() {
        
        let ref = Database.database().reference()
        ref.child("customer").observe(.childAdded, with: { (snapshot) in
            
            let title = (snapshot.value as AnyObject)["customerName"] as! String!
            let latitude = (snapshot.value as AnyObject)["latitude"] as! String!
            let longitude = (snapshot.value as AnyObject)["longitude"] as! String!

            
            let annotation = MKPointAnnotation()
            annotation.title = title
            annotation.coordinate = CLLocationCoordinate2D(latitude: (Double(latitude!))!, longitude: (Double(longitude!))!)

            self.mapView.addAnnotation(annotation)
            

        })}
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: (view.annotation?.coordinate)!, addressDictionary:nil))
        mapItem.name = (view.annotation?.title)!
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
        }
    
}

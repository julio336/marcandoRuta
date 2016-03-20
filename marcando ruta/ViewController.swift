//
//  ViewController.swift
//  marcando ruta
//
//  Created by Julio Ahuactzin on 20/03/16.
//  Copyright © 2016 Julio Ahuactzin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    
    @IBAction func segmentedMapa(sender: AnyObject) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapa.mapType = .Standard
        case 1:
            mapa.mapType = .Satellite
        default:
            mapa.mapType = .Hybrid
        }
        
    }
    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]){
        
        if startLocation == nil {
            startLocation = locations.first! as CLLocation
            var punto = CLLocationCoordinate2D()
            punto.latitude = (manager.location?.coordinate.latitude)!
            punto.longitude = (manager.location?.coordinate.longitude)!
            let pin = MKPointAnnotation()
            let lat = Double(round(100*punto.longitude)/100)
            let long = Double(round(100*punto.longitude)/100)
            pin.title = "Lat:\(lat), Long: \(long)"
            pin.subtitle = "Distancia recorrida: \(traveledDistance)"
            pin.coordinate = punto
            let region = MKCoordinateRegion(center: punto, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapa.setRegion(region, animated: true)
            mapa.addAnnotation(pin)
        } else {
            var distance = startLocation.distanceFromLocation(locations.last! as CLLocation)
            let lastDistance = lastLocation.distanceFromLocation(locations.last! as CLLocation)
            traveledDistance += Double(round(100*lastDistance)/100)
           // print("DISTANCE: \(distance)")
            //print("FULL DISTANCE: \(traveledDistance)")

            if distance > 50 {
                startLocation = locations.last! as CLLocation
                distance = 0.0
                var punto = CLLocationCoordinate2D()
                punto.latitude = (manager.location?.coordinate.latitude)!
                punto.longitude = (manager.location?.coordinate.longitude)!
                let pin = MKPointAnnotation()
                let lat = Double(round(100*punto.longitude)/100)
                let long = Double(round(100*punto.longitude)/100)
                pin.title = "Lat:\(lat), Long: \(long)"
                pin.subtitle = "Distancia recorrida: \(traveledDistance)"
                pin.coordinate = punto
                let region = MKCoordinateRegion(center: punto, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapa.setRegion(region, animated: true)
                
                mapa.addAnnotation(pin)
            }
        }
        lastLocation = locations.last! as CLLocation

    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController(title:"Error", message: "Error updating \(error.code)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { accion in })
        alerta.addAction(okAction)
        self.presentViewController(alerta, animated: true, completion: nil)
    }



}


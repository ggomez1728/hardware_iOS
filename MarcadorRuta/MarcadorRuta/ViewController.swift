//
//  ViewController.swift
//  MarcadorRuta
//
//  Created by Pollinion User on 04/03/16.
//  Copyright © 2016 Pollinion INC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var zoomButton: UIStepper!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var rastroButton: UIButton!
    
    private let manejador = CLLocationManager()
    
    var statePin: Bool = false
    var typeMap :Int = 0
    var zoomMapValu: Double = 0.01
    var firstLocation: CLLocation?=nil
    var startLocation: CLLocation?=nil
    var distance :Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        manejador.startUpdatingLocation()
        var punto = CLLocationCoordinate2D()
        punto.latitude = 19.52748
        punto.longitude = -96.92315
        let pin = MKPointAnnotation()
        pin.title = "Xalapa"
        pin.coordinate = punto
        mapa.addAnnotation(pin)
    }
    // El mapa debe estar centrado en la posición actual del dispositivo.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: self.zoomMapValu, longitudeDelta: self.zoomMapValu))
        self.mapa.setRegion(region, animated: true)
        if statePin == true{
            if self.startLocation == nil{
                self.firstLocation = location
                self.startLocation = location
                var punto = CLLocationCoordinate2D()
                punto.latitude = location.coordinate.latitude
                punto.longitude = location.coordinate.longitude
                self.firstLocation = location
                let pin = MKPointAnnotation()
                pin.title = "(\(punto.longitude), \(punto.latitude))."
                pin.subtitle = "\(location.distanceFromLocation(self.startLocation!))"
                pin.coordinate = punto
                mapa.addAnnotation(pin)
                self.distance = 0

            }
            else{
                let distance = location.distanceFromLocation(self.firstLocation!)
                if distance > 50{
                    var punto = CLLocationCoordinate2D()
                    punto.latitude = location.coordinate.latitude
                    punto.longitude = location.coordinate.longitude
                    self.firstLocation = location
                    let pin = MKPointAnnotation()
                    pin.title = "(\(punto.longitude), \(punto.latitude))."
                    pin.subtitle = "\(location.distanceFromLocation(self.startLocation!))"
                    pin.coordinate = punto
                    mapa.addAnnotation(pin)
                }
                self.distance = location.distanceFromLocation(self.startLocation!)

            }
            
        }
    }
    //El mapa debe tener un zoom in en el que se puedan ver las calles de la ciudad (usted decide cuánto es).
    @IBAction func zoom() {
        print(zoomButton.value)
        self.zoomMapValu = zoomButton.value
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    @IBAction func typeMapButton() {
        self.changeMap()
    }
    
    @IBAction func startRun() {
        statePin = !statePin
        if statePin == true{
            rastroButton.setTitle("Detener rastro", forState: UIControlState.Normal)
            self.startLocation = nil
        }
        else{
            let alert = UIAlertController(title: "Fin de recorrido", message: "Su recorrido total fue de \(distance) metros", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.distance = 0
            self.presentViewController(alert, animated: true, completion: nil)
            rastroButton.setTitle("Iniciar rastro", forState: UIControlState.Normal)
            let annotationsToRemove = mapa.annotations.filter { $0 !== mapa.userLocation }
            mapa.removeAnnotations( annotationsToRemove )
        }
    }
    
    func changeMap(){
        var textButton:String = ""
        typeMap++
        if typeMap == 3
        {
            typeMap = 0
        }
        switch typeMap{
        case 1:
            textButton = "Satélite"
            mapa.mapType = MKMapType.Satellite
            break
        case 2:
            textButton = "Híbrido"
            mapa.mapType = MKMapType.Hybrid

            break
        default:
            textButton = "Normal"
            mapa.mapType = MKMapType.Standard
            break
        }
        typeButton.setTitle(textButton, forState: UIControlState.Normal)

    }

}
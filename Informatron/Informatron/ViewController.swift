//
//  ViewController.swift
//  Informatron
//
//  Created by RMS on 12/04/2022.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var label : UILabel!
    var manager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Ready!"
        
        apiResponse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        
        label.text = "\(first.coordinate.longitude) | \(first.coordinate.latitude)"
    }

    func apiResponse(){
        let url = "https://api.openweathermap.org/data/2.5/weather?q=Gliwice,pl&APPID=b31c2399a91bd7f2a5019bbe3fa1e049"
        Session.default.request(url).responseJSON { response in

        switch response.result {
        case .success(let data):
        if let dataResponse = data as? [[String: Any]] {

        }
        case .failure(let error):
        print("Something went wrong: \(error)")
        }

        debugPrint(response.result)
        }
        
        let APIKey = "61c057a15b95115b35f5c980e64cb155"
        
        

    }
        
}


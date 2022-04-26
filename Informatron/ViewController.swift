//
//  ViewController.swift
//  Informatron
//
//  Created by RMS on 12/04/2022.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var label : UILabel!
    var manager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Ready!"
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
        
        request2()
    }
    
    func request1(){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Gliwice,pl&APPID=b31c2399a91bd7f2a5019bbe3fa1e049"
        
        let url = URL(string: urlString)
        
        guard url != nil else{
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(JSONData.self, from: data!)
                    
                    print(jsonData)
                }
                catch{
                    print("Error in JSON parsing")
                }
                
            }
        }
        
        dataTask.resume()
    }
    
    func request2(){
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Gliwice,pl&APPID=b31c2399a91bd7f2a5019bbe3fa1e049"
        
        AF.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response{ (responseData) in
            
            guard let data = responseData.data else {return}
            do{
                let coord = try JSONDecoder().decode(Coord.self, from: data)
                print(data)
            }
            catch{
                print("Error decoding")
            }
            
        }
    }
    
    
}


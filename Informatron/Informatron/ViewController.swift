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

    @IBOutlet var cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var weather : UILabel!
    @IBOutlet var searchButton : UIButton!
    //@IBOutlet var wind : UILabel!
    var manager : CLLocationManager = CLLocationManager()
    var lat = 0.0
    var lon = 0.0
    var weatherData : JSONData?
    var searchByLocation = "0"
    var search: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityName.text = "Ładowanie"
        temperature.text = ""
        weather.text = ""
        searchByLocation = search
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        DispatchQueue.global().async {
            sleep(2)
            self.apiResponse()
            sleep(1)
            print(self.weatherData?.name)
            DispatchQueue.main.async {
                self.cityName.text = self.weatherData?.name
                self.temperature.text = String(format: "%.1f", (self.weatherData?.main?.temp ?? 0.0)) + "°C"
                self.weather.text = self.weatherData?.weather?[0].main
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        lat = first.coordinate.latitude
        lon = first.coordinate.longitude
    }

    func apiResponse() {
        //let apiKey = "61c057a15b95115b35f5c980e64cb155"
        //let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
       
            //let url =  "https://api.openweathermap.org/data/2.5/weather?q=Gliwice,pl&APPID=61c057a15b95115b35f5c980e64cb155"
        let url : String
        if(searchByLocation == "0") {
            url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&lang=pl&APPID=61c057a15b95115b35f5c980e64cb155"
        }
        else {
            url = "https://api.openweathermap.org/data/2.5/weather?q=\(searchByLocation)&units=metric&lang=pl&APPID=61c057a15b95115b35f5c980e64cb155"
        }
        
        /*AF.request(url).responseJSON { response in
            switch response.result {
               case .success(let value):
                let json = response.result
                print(json)
               case .failure(let error):
                print(error)
            }
        }*/
        
        DispatchQueue.global().async {
            AF.request(url).responseString { response in
                //print(response.value)
                do{
                    self.weatherData = try JSONData(response.value!)
                    //print(self.weatherData?.name)
                }
                catch{
                    print(error)
                }
            }
        }

    }
    
        
}



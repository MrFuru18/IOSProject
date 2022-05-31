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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var manager : CLLocationManager = CLLocationManager()
    var lat = 0.0
    var lon = 0.0
    var weatherData : JSONData?
    var searchByLocation = "0"
    var search: String = "0"
    var success : Bool = false
    var errors = ["{\"cod\":\"400\",\"message\":\"Nothing to geocode\"}",
                  "{\"cod\":\"404\",\"message\":\"city not found\"}",
                  ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        cityName.text = "Ładowanie"
        temperature.text = ""
        weather.text = ""
        searchByLocation = search
        
        activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
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
            sleep(2)
            DispatchQueue.main.async {
                if(self.success) {
                self.cityName.text = self.weatherData?.name
                self.temperature.text = String(format: "%.1f", (self.weatherData?.main?.temp ?? 0.0)) + "°C"
                self.weather.text = self.weatherData?.weather?[0].weatherDescription
                }
                else
                {
                    self.cityName.text = "Błąd"
                }
                
                self.activityIndicator.stopAnimating()
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
        let url : String
        if(searchByLocation == "0") {
            url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&lang=pl&APPID=61c057a15b95115b35f5c980e64cb155"
        }
        else {
            url = "https://api.openweathermap.org/data/2.5/weather?q=\(searchByLocation)&units=metric&lang=pl&APPID=61c057a15b95115b35f5c980e64cb155"
        }
        
        DispatchQueue.global().async {
            AF.request(url).responseString { response in
                do{
                    //print(response.value!)
                    self.success = false
                    if(self.errors.contains(response.value!)) {
                        self.showToast(message: "Nie znaleziono")
                    }
                    else {
                        self.success = true
                        self.weatherData = try JSONData(response.value!)
                    }
                }
                catch{
                    print(error)
                }
            }
        }

    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
        
}



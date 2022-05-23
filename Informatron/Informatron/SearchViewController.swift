//
//  SearchViewController.swift
//  Informatron
//
//  Created by Votar Bicnick on 19/05/2022.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UITextField!
    @IBOutlet var searchButton: UIButton!
    var search: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wyszukaj"
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        search = searchBar.text ?? ""
        
        let destinationVC = segue.destination as! ViewController
        destinationVC.search = search
    }
    
    @IBAction func searchRequest(sender: UIButton){
        search = searchBar.text ?? ""
        apiResponse()
    }
    
    func apiResponse() {
        let url : String
        
        url = "https://api.openweathermap.org/data/2.5/weather?q=\(search)&units=metric&lang=pl&APPID=61c057a15b95115b35f5c980e64cb155"

        
        DispatchQueue.global().async {
            AF.request(url).responseString { response in
                //print(response.value)
                do{
                    if (response.value == "{\"cod\":\"404\",\"message\":\"city not found\"}"){
                        self.showToast(message: "Nie znaleziono miasta")
                    }
                    else {
                        let vc = ViewController(nibName: "ViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
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

//
//  SearchViewController.swift
//  Informatron
//
//  Created by RMS on 19/05/2022.
//

import UIKit
import Alamofire
import SwiftUI

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UITextField!
    @IBOutlet var searchButton: UIButton!
    var search: String = ""
    var tempSearch: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = "Wyszukaj"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sbn") {search = "0"}
        else {
            let tempSearch = searchBar.text ?? ""
            search = tempSearch.folding(options: .diacriticInsensitive, locale: nil).replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "ł", with: "l").replacingOccurrences(of: "Ł", with: "L").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            //search = replaceInString(inputString: search)
            print(search)
        }
        
        let destinationVC = segue.destination as! ViewController
        destinationVC.search = search
    }
    
    private func replaceInString(inputString : String = "") -> String {
        let toChange = ["§", "£", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "-", "=", "[", "]", "{", "}", "'", "\"", "\\", "|", "<", ">", ",", ".", "?", "/", "`", "~", ":", ";", "€", "£", "¥"]
        var result = inputString
        
        toChange.forEach{sign in
            result = result.replacingOccurrences(of: sign, with: "")
        }
        
        return result
    }
    
}

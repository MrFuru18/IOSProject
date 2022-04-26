//
//  NetworkingClient.swift
//  Informatron
//
//  Created by RMS on 26/04/2022.
//

import Foundation
import Alamofire

class NetworkingClient{
    
    typealias WebServiceResponce = ([[String: Any]]?, Error) -> Void
    
    func execute (_ url: URL, completion: WebServiceResponce){
    
        /*AF.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            }else if let jsonArray = response.result.value as? [[String: Any]]{
                completion(jsonArray, nil)
            }else if let jsonDict = response.result.value as? [String:Any]{
                completion([jsonDict], nil)
            }
        }*/
    }
}

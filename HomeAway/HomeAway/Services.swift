//
//  Services.swift
//  HomeAway
//
//  Created by Nex on 9/29/19.
//  Copyright © 2019 nsn. All rights reserved.
//

import UIKit

class Services: NSObject {

    private static let client_id = "MTg1OTUzMzl8MTU2OTQzNTgxNy4yNQ"
    static let baseURL = "https://api.seatgeek.com/2/events"
    
    let keys = ["title", "venue", "datetime_utc" , "performers"]
    var rValue = [String:Any]()
    var rValues = [[String:Any]]()
    
    func fetchEventData(for strUrl:String, completion:@escaping ([[String:Any]]) -> ())  {

        guard let url = URL(string: strUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {
                return
            }
            
            do {
                self.rValues.removeAll()
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    for (key, val) in json {
                        if(key == "events"){
                            let events = val as! [[String:Any]]
                            
                            for item in events {
                                for (itmKey, itmVal) in item {
                                    for k in self.keys {
                                        if(itmKey == k){
                                            if( k == "venue"){
                                                let venue = itmVal as! [String:Any]
                                                let i = venue["extended_address"] as! String
                                                self.rValue["extended_address"] = i
                                            }else if( k == "performers"){
                                                let  performers = itmVal as! [[String:Any]]
                                                if(performers.count > 0) {
                                                    let performer = performers[0]
                                                    if let j = performer["image"] as? String {
                                                        self.rValue["imageUrlStr"] = "no image"
                                                        self.rValue["image"] = UIImage(named: "noImage")
                                                        self.rValue["imageUrlStr"] = j

//                                                        self.fetchEventImage(for: j, completion: { image in
//                                                            self.rValue["image"] = image
//                                                        })
                                                    }else {
                                                        self.rValue["imageUrlStr"] = "no image"
                                                        self.rValue["image"] = UIImage(named: "noImage")
                                                    }
                                                }
                                            }else if (k == "title" || k == "datetime_utc"){
                                                let l = itmVal as! String
                                                self.rValue[k] = l
                                            }
                                            else {
                                                self.rValue[k] = " "
                                            }
                                        }
                                    }
                                }
                                self.rValues.append(self.rValue)
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            completion(self.rValues)
            return
            }.resume()
    }
    
    func fetchEventImage(for strUrl:String, completion:@escaping (UIImage) -> ())  {
        
        guard let url = URL(string: strUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {
                return
            }
            
            var image = UIImage()
            image = UIImage(data: data) ?? UIImage(named: "noImage")!
            completion(image)
            return
            }.resume()
        
        
    }
    
    func stringUrlForEventData(forQuery query:String) -> String{
        //print(Services.baseURL  + "?client_id=\(Services.client_id)&\(query)")
        return  Services.baseURL  + "?client_id=\(Services.client_id)&\(query)"
    }
    
    
}

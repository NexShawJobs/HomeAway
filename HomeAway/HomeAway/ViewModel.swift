//
//  ViewModel.swift
//  HomeAway
//
//  Created by Nex on 9/29/19.
//  Copyright © 2019 nsn. All rights reserved.
//

import UIKit
class ViewModel: NSObject {
    @IBOutlet weak var services: Services!
    var eventData:Data = Data()
    var eventArray = [[String:Any]]()
    
    //get Data
    func fetchEventData(for urlString:String, completion:@escaping () -> ()){
        services.fetchEventData(for: urlString, completion: {eventA in
            self.eventArray = eventA
            completion()
        })
    }
    //URL for event data
    func stringUrlForEventData(forQuery query:String) -> String{
        return  services.stringUrlForEventData(forQuery: query)
    }
    
    func fetchEventImage(for strUrl:String, index:Int, completion:@escaping () -> ())  {
        
        services.fetchEventImage(for: strUrl, completion: { image in
            if(self.eventArray.count > 0){
                self.eventArray[index]["image"] = image
            }
            completion()
        })
        
    }
}

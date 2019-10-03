//
//  DetailViewController.swift
//  HomeAway
//
//  Created by Nex on 9/25/19.
//  Copyright © 2019 nsn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var rValue = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imageView.image = rValue["image"] as? UIImage
        self.imageView.layer.cornerRadius = 20.0
        self.imageView.clipsToBounds = true
        
        self.timeLabel.text = rValue["datetime_utc"] as? String
        self.locationLabel.text = rValue["extended_address"] as? String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

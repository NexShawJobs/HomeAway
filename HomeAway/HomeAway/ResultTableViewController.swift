//
//  ResultTableViewController.swift
//  HomeAway
//
//  Created by Nex on 9/25/19.
//  Copyright © 2019 nsn. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController ,UISearchBarDelegate {
    @IBOutlet var viewModel: ViewModel!
    var eventResponseData: Data = Data()
    var eventArray = [[String:Any]]()
    var rowIndex = 0
    let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = 90
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = ""
        let attributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 41/255, green: 70/255, blue: 88/255, alpha: 1.0)
        searchBar.showsCancelButton = true
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.eventArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let img = (self.eventArray[indexPath.row]["image"] as! UIImage)
        cell.imageView?.image = img
        let itemSize = CGSize.init(width: 70, height: 70)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        cell.textLabel?.text = (self.eventArray[indexPath.row]["title"] as! String)
        
        cell.detailTextLabel?.numberOfLines = 2
        let location = (self.eventArray[indexPath.row]["extended_address"] as! String)
        let date = (self.eventArray[indexPath.row]["datetime_utc"] as! String)
        let txt = "\(location)\n\(date)"
        
        cell.detailTextLabel?.text = txt
        // Configure the cell...
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showD" {
            for navItem in(self.navigationController?.navigationBar.subviews)! {
                for itemSubView in navItem.subviews {
                    if let largeLabel = itemSubView as? UILabel {
                        largeLabel.text = self.title
                        largeLabel.numberOfLines = 2
                        largeLabel.lineBreakMode = .byWordWrapping
                    }
                }
            }
            let index = self.tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! DetailViewController
            vc.rValue = self.eventArray[index!]
            segue.destination.navigationItem.title = self.eventArray[index ?? 0]["title"] as? String
        }
    }
    
    // Mark:- Data
    func getData(forQuery query: String) {
        self.viewModel.fetchEventData(for: viewModel.stringUrlForEventData(forQuery: "q=" + query), completion: {
            
            self.eventArray = self.viewModel.eventArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            if(self.eventArray.count > 0){
                for i in 0...self.eventArray.count - 1 {
                    let strUrl = self.eventArray[i]["imageUrlStr"] as! String
                    if(strUrl != "no image"){
                        self.viewModel.fetchEventImage(for: strUrl, index: i, completion: {
                            self.eventArray[i]["image"] = self.viewModel.eventArray[i]["image"]

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
            }
        })
        

    }
    
    //Mark:- Search Bar Delegate
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
        guard let txt = textFieldInsideSearchBar.text else {
            return
        }
        
        let queryText = String(txt.map {
            $0 == " " ? "+" : $0
        })
        
        self.getData(forQuery: queryText)
        if(queryText.count == 0){
            self.eventArray.removeAll()
            self.tableView.reloadData()
        }
    }
    

}

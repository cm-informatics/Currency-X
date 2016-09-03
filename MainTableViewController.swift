//
//  MainTableViewController.swift
//  Currency X
//
//  Created by Christian Mansch on 01.09.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var rates = [String:AnyObject]()
    
    var factor = 1.0
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getRates("USD")
    }

    func getRates(base: String) {
        
        let url = NSURL(string: "http://api.fixer.io/latest?base=\(base)")!
        
        let dataTask = defaultSession.dataTaskWithURL(url) {
            (data, response, error) in
            
            if (error != nil){
                print(error?.localizedDescription)
            }
            else if let httpResponse = response as? NSHTTPURLResponse{
                if httpResponse.statusCode == 200{
                    print("ALL OK")
                    self.parseJSON(data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func parseJSON(data: NSData?){
        print("The Data is: \(data)")
        
        do{
            if let data = data{
                
                self.rates = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! [String:AnyObject]
               // print(self.rates)
            }
        }
        catch{
            print("Something went wrong")
        }
        dispatch_async(dispatch_get_main_queue())
        {
            //self.currencyTextView.text = "\(self.rates)"
            self.tableView.reloadData()
        }
    }

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1
        {
            if let exchangeRates = rates["rates"] as? NSDictionary{
                return (exchangeRates.count)
            }
            else{
                return 0
            }
        }
        else{
            return 1
        }
 
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        
        if indexPath.section == 0{
            if let base = rates["base"]
            {
                cell.textLabel?.text = base as? String
                cell.detailTextLabel?.text = "1.0"
                
            }
        }
        else{
            if let exchangeRates = rates["rates"] as? NSDictionary{
            
                let keys = exchangeRates.allKeys
                let values = exchangeRates.allValues
            
                cell.textLabel?.text = keys[indexPath.row] as? String
                //cell.detailTextLabel?.text = "\(values[indexPath.row])"
                cell.detailTextLabel?.text = "\(((values[indexPath.row]) as! Double)*factor)"
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Base Rate"
        }
        else{
            return "Exchange Rates"
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0{
                print("Row \(indexPath.row) selected")
                factor = factor * 2
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

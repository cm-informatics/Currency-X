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
    
    var currency_long = NSDictionary()
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Preapare Long Currency Names
        
        let JSONFile = NSBundle.mainBundle().pathForResource("currency_long", ofType: "json")
        let data = NSData(contentsOfFile: JSONFile!)!
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            currency_long =  NSDictionary(dictionary: json as! [NSString : NSString])
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
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
                    self.parseJSON(data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func parseJSON(data: NSData?){
        
        do{
            if let data = data{
                
                self.rates = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! [String:AnyObject]
            }
        }
        catch{
            print("Something went wrong")
        }
        dispatch_async(dispatch_get_main_queue())
        {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CurrencyTableViewCell

        // Configure the cell...
        
        if indexPath.section == 0{
            if let base = rates["base"]
            {
                cell.lable_fullname.text = currency_long.objectForKey(base) as? String
                cell.label_shorthand.text = base as? String
                cell.label_amount.text = "\(factor)"
            }
        }
        else{
            if let exchangeRates = rates["rates"] as? NSDictionary{
            
                let keys = exchangeRates.allKeys
                let values = exchangeRates.allValues
                
                // Look up the full currency name for the shorthand
                let full_currency = currency_long.objectForKey(keys[indexPath.row]) ?? ""
                
                cell.lable_fullname.text = "\(full_currency!)"
                cell.label_shorthand.text = "\(keys[indexPath.row])"
                cell.label_amount.text = "\(((values[indexPath.row]) as! Double)*factor)"
            }
            
        }
        
        // Set the flags and put a lightGray border to them
        let theFlag = "\(cell.label_shorthand.text!.stringByAppendingString(".PNG"))"
        cell.country_flag.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.country_flag.layer.borderWidth = 0.75
        cell.country_flag.image = UIImage(named: theFlag)

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
            
            let alertView = UIAlertController(title: "Eingabe", message: "Bitte geben Sie eine Betrag ein.", preferredStyle: .Alert)
            alertView.addTextFieldWithConfigurationHandler { (textField: UITextField) in
                textField.keyboardType = .DecimalPad
            }
            
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler:
                {
                    (action: UIAlertAction) in
                    
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                    cell?.detailTextLabel?.text = alertView.textFields?.first?.text
                    
                    alertView.textFields?.first?.text = alertView.textFields?.first?.text?.stringByReplacingOccurrencesOfString(",", withString: ".")
                    
                    // Perform the exchange only if the double conversion is possible
                    if let exchangeFactor = Double(alertView.textFields!.first!.text!)
                    {
                        self.factor = exchangeFactor
                        tableView.reloadData()
                    }
            }))
            
            alertView.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))

            self.presentViewController(alertView, animated: true, completion: nil)
            
        }
        else if indexPath.section == 1{
            let cell: CurrencyTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! CurrencyTableViewCell
            getRates((cell.label_shorthand.text)!)
            
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

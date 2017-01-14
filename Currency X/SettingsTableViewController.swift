//
//  SettingsTableViewController.swift
//  Currency X
//
//  Created by Christian Mansch on 07.01.17.
//  Copyright © 2017 Christian Mansch. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {

    let mtvc_obj = MainTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem)
    {
        let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as! DefaultBaseRateTableViewCell
        
        if let rate = Double(cell.baseRateTextField.text!)
        {
            mtvc_obj.defaults.set(rate, forKey: "default_Base")
        }

        self.dismiss(animated: true, completion: nil)
        print(mtvc_obj.defaults.object(forKey: "default_Base") as Any)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Standard-währung festlegen"
        }
        else{
            return "Standard-betrag festlegen"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dcc", for: indexPath)
            cell.textLabel?.text = "Default Währung"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "brc", for: indexPath) as!DefaultBaseRateTableViewCell
            //cell.baseRateTextField.text = value.defaults.object(forKey: "default_Base")
            if let value = mtvc_obj.defaults.object(forKey: "default_Base") as? Double
            {
                cell.baseRateTextField.text = String(value)
            }
            
            return cell
        }

        // Configure the cell...

        
    }
    
  /*  func textFieldDidEndEditing(_ textField: UITextField) {
        let value = MainTableViewController()
        if let rate = Int(textField.text!)
        {
            value.defaults.set(rate, forKey: "default_Base")
        }
        
        
    }*/
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

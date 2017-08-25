//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var nombre: UILabel!
    
    //@IBOutlet var holasection: UITableViewSection!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none;
        
        nombre.text = nombrecliente
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Define el contenido de la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        
        return cell
    }*/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---")
        print(indexPath.row)
        print("---")
        
        /*if indexPath.row == 0 {
            dismiss(animated: true, completion: nil)
        }else*/
        
        if indexPath.row == 0 {
            
            /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "fourSB") as! ViewController
            
            var refreshAlert = UIAlertController(title: "miituo", message: "versión 1.0", preferredStyle: UIAlertControllerStyle.alert)
            
            let action = (UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                print("Cerrando...")
                
                //DispatchQueue.global(qos: .userInitiated).async {
                //   DispatchQueue.main.async {
                
                //self.dismiss(animated: true, completion: nil)
                //}
                //}
            }))
            refreshAlert.addAction(action)
            present(refreshAlert, animated: true)*/
        }
        else if indexPath.row == 3 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "fourSB") as! ViewController
            
            var refreshAlert = UIAlertController(title: "Atención", message: "¿Desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.alert)
            
            let action = (UIAlertAction(title: "Sí", style: .default, handler: { (action: UIAlertAction!) in
                
                print("Cerrando...")
                
                //DispatchQueue.global(qos: .userInitiated).async {
                //   DispatchQueue.main.async {
                
                //self.dismiss(animated: true, completion: nil)
                //self.dismiss(animated: true, completion: {
                 
                 let prefs = UserDefaults.standard
                 prefs.removeObject(forKey:"tutoya")
                 prefs.removeObject(forKey:"celular")
                 
                 //myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                 //myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                 
                 self.present(myAlert, animated: true, completion: nil)
                //})
                //}
                //}
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
             
             print("Nada...")
             
             }))
        
            refreshAlert.addAction(action)
            present(refreshAlert, animated: true)
        }
    }
    
    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

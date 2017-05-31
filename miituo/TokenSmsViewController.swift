//
//  TokenSmsViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 25/04/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class TokenSmsViewController: UIViewController {

    
    @IBOutlet weak var tokensms: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func launchpolizas(_ sender: Any) {
        
        //validate toke -- else showmessage
        if tokensms.text == ""{
            
            showmessage(message: "Favor de colocar token")
            
        } else {
        //call verify token to validate token...
        
        //set default to save onboarding set already
        
        //and launch polizas view -- just launch (the data is already loaded)
        //launch second view with data - show table and polizas
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(vc, animated: true, completion: nil)
        }
        
    }
    

    //Get out of the textfield*********************************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Termina edicion
        self.view.endEditing(true)
    }
    
    //Cuando das clic en return dek teclado*********************************************
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

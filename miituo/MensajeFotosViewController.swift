//
//  MensajeFotosViewController.swift
//  miituodev
//
//  Created by John A. Cristobal on 22/08/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class MensajeFotosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWW(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    //elaunch polizas----------------------------------------------------------------------------
    func launcfotos(){
        //launch view to confirm odometer
        
        /*let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
         //openview
         self.present(odometerview, animated: true, completion: nil)
         */
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "photoscar") as! PhotosCarViewController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        //launch second view with data - show table and polizas
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(myAlert, animated: true, completion: nil)
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

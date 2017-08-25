//
//  DetalleViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 29/05/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet var fecha: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fecha.text = "Tu siguiente reporte será el: \(arregloPolizas[Int(valueToPass)!]["limitefecha"]! as String)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

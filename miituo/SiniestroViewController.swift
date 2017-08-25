//
//  SiniestroViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 03/05/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class SiniestroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func makeCall(_ sender: Any) {
        
        guard let url = URL(string: "telprompt://11025280") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
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

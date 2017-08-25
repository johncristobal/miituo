//
//  ReportConfirmViewController.swift
//  devmiituo
//
//  Created by vera_john on 31/03/17.
//  Copyright © 2017 VERA. All rights reserved.
/*
    Confirar odometro mensual....
 */
//

import UIKit
import Toaster

var odometro = ""
var flag = false

class ReportConfirmViewController: UIViewController {

    var datareturned = [String:String]()
    
    @IBOutlet var textres: UITextField!
    
    var blurEffect:UIBlurEffect? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        odometro = ""
        flag = false
        // Do any additional setup after loading the view.

        textres.text = odometro
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func closeWW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //@IBOutlet var closeW: UIBarButtonItem!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendOdo(_ sender: Any) {
        let odometroaenviar = textres.text! as String
        
        if odometroaenviar == "" {
            showmessage(message: "Es necesario capturar los kms. que marca el odómetro.")
        }else if odometroaenviar != odometrouno {
            ToastView.appearance().bottomOffsetPortrait = 350.0
            //ToastView.appearance().backgroundColor = UIColor.blue
            let to = Toast(text: "Los odómetros no coinciden, por favor verifícalos")
            to.show()
        }
        else{
            odometro = odometroaenviar
            //blur efecto when launch pop
            //self.view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            
            /*blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)*/
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "popodometro")
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(myAlert, animated: true, completion: nil)
            
            print("Despues de...")
            
            /*var refreshAlert = UIAlertController(title: "Confirmar odometro", message: "¿Desea confirmar el odometro?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                self.sendReportOdometer()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)*/
        }
    }
    
    //Get out of the textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Termina edicion
        self.view.endEditing(true)
    }
    
    //Cuando das clic en return dek teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

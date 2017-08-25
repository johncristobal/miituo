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
        if tokensms.text == "" {
            
            showmessage(message: "Favor de colocar token")            
        } else {
            //call verify token to validate token...
            
            //set default to save onboarding set already
            
            //and launch polizas view -- just launch (the data is already loaded)
            //launch second view with data - show table and polizas
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
            //self.present(vc, animated: true, completion: nil)
            UserDefaults.standard.setValue("1", forKey: "sesion")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
            
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            //launch second view with data - show table and polizas
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
            self.present(myAlert, animated: true, completion: nil)
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
    
    @IBAction func sendTokenAgain(_ sender: Any) {

        let telefon = UserDefaults.standard.value(forKey: "celular") as! String
        //func getSms(telefon:String){
                    
            let url = URL(string: "\(ip)TemporalToken/GetTemporalTokenPhone/"+telefon+"/"+polizaparasms!+"/AppToken")!
            let session = URLSession.shared;
            let loadTask = session.dataTask(with: url){(data,response,error) in
                if error != nil{
                    showmessage(message: "Error de conexiòn \(error)")
                } else {
                    if let urlContent = data{
                        do {
                            let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            print("iMPRIMIENDO")
                            let dato = json as! NSArray
                            tokentemp = dato[0] as! String
                            print("Valor de vuelto de sms: \(tokentemp)")
                            //get data from client....
                            //let cliente = json.value(forKey: "Client") as! NSArray
                            //print(cliente)
                            DispatchQueue.main.async {
                                
                                let refreshAlert = UIAlertController(title: "Se ha enviado un nuevo token", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                                
                            }                            
                        } catch{
                            showmessage(message: "Error en JSON token.")
                        }
                        
                        //launch second view with data - show table and polizas
                        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                        //self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            loadTask.resume()
        //}
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

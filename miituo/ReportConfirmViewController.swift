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
            showmessage(message: "Colocar confirmación de odómetro")
        }else if odometroaenviar != odometrouno {
            ToastView.appearance().bottomOffsetPortrait = 350.0
            //ToastView.appearance().backgroundColor = UIColor.blue
            let to = Toast(text: "Los odómetros no coinciden")
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
    
    //thread to send odometer
    /*func sendReportOdometer(){
        let cadena = textres.text
        
        // to base64 => yhis is going to be in the thread to send photos
        //let imageData:NSData = UIImagePNGRepresentation(comrimidad)! as NSData
        
        //let strBase64 = comrimidad.base64EncodedString(options: [])
        
        let todosEndpoint: String = "\(ip)ReportOdometer/"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let datainter: [String: Any] = ["PolicyId":"59","PolicyFolio":"884489275","Odometer":cadena,"ClientId":"70"]
        let newTodo: [String: Any] = ["Type": "1","ImageItem":datainter]
 
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let semaphore = DispatchSemaphore(value: 0);
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                //print("error \(httpResponse.description)")
                //print("error \(httpResponse.)")
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData, encoding: String.Encoding.utf8) {
                        print("Valor de retorno odometro: \(str)")
                        valordevuelto = str

                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                }else {
                    //showmessage(message: "El odometro debe ser mayor al anterior")
                }
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedTodo.description)
                //print("The todo is message:  \(receivedTodo["Message"] as! String)")
                //valordevuelto = receivedTodo["Message"] as! String
                if let meessage = receivedTodo["Message"] {
                    showmessage(message: meessage as! String)
                    odometro = "no"
                }else{
                
                    flag = true
                    
                    let totalmes = receivedTodo["Amount"]
                    self.datareturned["odohoy"] = String(describing:totalmes)
                
                    let tarifafijames = receivedTodo["Parameters"] as! NSArray
                    let tarifafija = (tarifafijames[0] as AnyObject).value(forKey: "Amount") as! Int
                    let promocion = (tarifafijames[1] as AnyObject).value(forKey: "Amount") as! Int
                
                    print("tarifafjia: \(tarifafija)")
                    print("promo: \(promocion)")
                
                    //update values to send to the cystom alert
                    //odometro = String(describing:promocion)
                    odometro = cadena!
                    
                    semaphore.signal();
                    
                    DispatchQueue.global(qos: .userInitiated).async { // 1
                        //let overlayImage = self.faceOverlayImageFromImage(self.image)
                        DispatchQueue.main.async { // 2
                            
                            if odometro != "no" {
                                //show alert with data
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
                                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                
                                
                                
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
            } catch  {
                print("error parsing response from POST on /todos")
                //return 125445
            }
        }
        
        task.resume()
        //semaphore.wait()
        let resut = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: 2000000000))
        print("Semaforo:\(resut)")
        
        
        print("Out of here")
    }*/
    
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

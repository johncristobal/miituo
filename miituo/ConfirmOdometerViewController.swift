//
//  ConfirmOdometerViewController.swift
//  devmiituo
//
//  Created by vera_john on 30/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit

var odometrouno = ""

class ConfirmOdometerViewController: UIViewController {

    //@IBOutlet var textres: UITextField!

    @IBOutlet var textoantes: UILabel!
    @IBOutlet var lastodo: UITextField!
    @IBOutlet var textres: UITextField!
    
    @IBOutlet var upconstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Here in conform odometer: \(valordevuelto)")
        // Do any additional setup after loading the view.
        
        //perogress...
        /*let flag = true
        while flag {
            if valordevuelto != "" {
                break;
            }
        }
        
        if valordevuelto != "1000" {
            textres.text = valordevuelto
        }*/
        odometrouno = ""
        textres.text = odometrouno
        
        let rowsel = Int(valueToPass)!
        let poliza = arregloPolizas[rowsel]["lastodometer"]! as String
        print("idpoliza----------------\(poliza)")
        lastodo.text = poliza
        
        if poliza == "0"{
            
            //lastodo.isHidden = true
            //textoantes.isHidden = true
            //upconstraint.constant = -25
        }
        
        //textres.isFocused = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToPolizas(_ sender: Any) {
        
        //recupero texto
        //valido que no sea vacio
        //envio a siguiente pantalla para volver a colocar odometro
        let cadena = textres.text
        
        if cadena == "" {
            showmessage(message: "Es necesario capturar los kms. que marca el odómetro.")
        }else{
            
            odometrouno = cadena!
            
            //launch view to confirm odometer
            let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "reportOdo") as! ReportConfirmViewController
            
            //openview
            self.present(odometerview, animated: true, completion: nil)

        }
        
        /*let todosEndpoint: String = "\(ip)ImageProcessing/ConfirmOdometer"
        //let todosEndpoint: String = "http://192.168.1.109:1000/api/ImageProcessing/"
        //let todosEndpoint: String = "http://192.168.1.109:1000/api/ClientUser/"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let newTodo: [String: Any] = ["Type": "5", "Odometer": cadena, "PolicyId":"59" ,"PolicyFolio":"884489275"]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
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
                print("error \(httpResponse.description)")
                //print("error \(httpResponse.)")
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData, encoding: String.Encoding.utf8) {
                        print("Valor de retorno: \(str)")
                        valordevuelto = str
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
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
                print("The todo is message:  \(receivedTodo["Message"] as! String)")
                valordevuelto = receivedTodo["Message"] as! String
            } catch  {
                print("error parsing response from POST on /todos")
                //return
            }
        }
        task.resume()
        
        //launch view to confirm odometer
        let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        
        //openview
        self.present(odometerview, animated: true, completion: nil)*/
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

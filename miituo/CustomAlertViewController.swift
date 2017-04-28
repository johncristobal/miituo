//
//  CustomAlertViewController.swift
//  devmiituo
//
//  Created by vera_john on 04/04/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit
import CoreData

class CustomAlertViewController: UIViewController {

    var rowsel = 0;
    
    @IBOutlet var odometrohoy: UILabel!

    //@IBOutlet var odometroanterior: UILabel!
    //@IBOutlet var kilometrosrecorridos: UILabel!
    @IBOutlet var tarifaporkm: UILabel!
    //@IBOutlet var prima: UILabel!
    //@IBOutlet var basemes: UILabel!
    @IBOutlet var promo: UILabel!
    //@IBOutlet var totalapagar: UILabel!
    
    let alertaloading = UIAlertController(title: nil, message: "Subiendo información...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        valordevuelto = ""
        //perogress...
        /*let flag = true
        while flag {
            if odometro != "" {
                break;
            }
        }*/
        
        if odometro != ""{
            odometrohoy.text = odometro
            
            tarifaporkm.text = tarifaporkmlast
            
            promo.text = promolast
        }
        
        // Do any additional setup after loading the view.
        rowsel = Int(valueToPass)!
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lastStep(_ sender: Any) {
        
        //open alert to sincronizar
        openloading(mensaje: "Subiendo información...")

        /// ----------- send confirmreport ------------ ///
        let todosEndpoint: String = "\(ip)ReportOdometer/Confirmreport"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
 
        let newTodo: [String: Any] = ["Type":"1","PolicyId":arregloPolizas[rowsel]["idpoliza"] as! String,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"] as! String,"Odometer":odometro,"ClientId":arregloPolizas[rowsel]["idcliente"] as! String]
        
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
                
            } catch  {
                print("error parsing response from POST on /todos")
                //return 125445
            }
            
        }
        task.resume()
        
        //DispatchQueue.main.async {
        while true {
            if valordevuelto != ""{
                break;
            }
        }

        alertaloading.dismiss(animated: true, completion: {
        
            print("Valoe ------------ devuelro ----------")
            print(valordevuelto)

            if valordevuelto == "true" || valordevuelto == "false"{
            
            let refreshAlert = UIAlertController(title: "Odometro", message: "Odometro enviado satisfactoriamente", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                
                do{
                    //UpdatereportStet from CoreData
                    //store do core data
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let requestpolizas = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
                    //let fetchpolcar = NSBatchUpdateRequest(fetchRequest: requestpolizas)
                    //let resultpolcar = try context.execute(fetchpolcar)
                }catch {
                    showmessage(message: "Error al actualizar estatus")
                }
                
                
                //launch second view with data - show table and polizas
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                self.present(vc, animated: true, completion: nil)
                
                self.dismiss(animated: true, completion: nil)
            }))
            
            /*refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
             
             //launch second view with data - show table and polizas
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
             self.present(vc, animated: true, completion: nil)
             }))*/
            
            self.present(refreshAlert, animated: true, completion: nil)
            } else {
                
                let refreshAlert = UIAlertController(title: "Odometro", message: "Error al enviar odometro. Intente más tarde", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                    //launch second view with data - show table and polizas
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                    self.present(vc, animated: true, completion: nil)
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                
                /*refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                 
                 //launch second view with data - show table and polizas
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                 self.present(vc, animated: true, completion: nil)
                 }))*/
                
                self.present(refreshAlert, animated: true, completion: nil)
            }
        })
    }
    
    
//------------------------loading page------------------------------------
    func openloading(mensaje: String){
        
        alertaloading.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alertaloading.view.addSubview(loadingIndicator)
        present(alertaloading, animated: true, completion: nil)
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

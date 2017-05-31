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
   // @IBOutlet var odometroanterior: NSLayoutConstraint!
    
    @IBOutlet var odometroanterior: UILabel!
    
    @IBOutlet var kilometrosrecorridos: UILabel!
    @IBOutlet var tarifaporkm: UILabel!
    @IBOutlet var promo: UILabel!
    @IBOutlet var promoshow: UILabel!
    
    @IBOutlet var prima: UILabel!
    @IBOutlet var basemes: UILabel!

    @IBOutlet var totalapagar: UILabel!
    
    @IBOutlet var primashow: UILabel!
        
    @IBOutlet var tafifakms: UILabel!
    
    let alertaloading = UIAlertController(title: "Reportando", message: "Subiendo información...", preferredStyle: .alert)
    
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
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        //let finalnumber = numberFormatter.string(from: NSNumber(value: largeNumber))
        
        if odometro != "" {
            let valuehoy: Float = Float(odometro)!
            //odometrohoy.text = numberFormatter.string(from: NSNumber(value: Int(odometro)!))//odometro
            odometrohoy.text = "\(String.localizedStringWithFormat("%.2f", valuehoy))"

            let valueanterior: Float = Float(odometroanteriorlast)!
            //odometroanterior.text = numberFormatter.string(from: NSNumber(value: Int(odometroanteriorlast)!))//odometroanteriorlast
            odometroanterior.text = "\(String.localizedStringWithFormat("%.2f", valueanterior))"
            
            let valuerecorridos: Float = Float(kilometrosrecorridoslast)!
            //kilometrosrecorridos.text = numberFormatter.string(from: NSNumber(value: Int(kilometrosrecorridoslast)!))//kilometrosrecorridoslast
            kilometrosrecorridos.text = "\(String.localizedStringWithFormat("%.2f", valuerecorridos))"

            //let otrostring = Float(tarifaporkmlast)
            let otrokmlast = numberFormatter.string(from: NSNumber(value: Double(tarifaporkmlast)!))
            tarifaporkm.text = "$ \((otrokmlast!))"

            //basemes.text = "$ \(basemeslast)"
            let value: Float = Float(basemeslast)!
            basemes.text = "$ \(String.localizedStringWithFormat("%.2f", value))"

            //let otrototal = numberFormatter.string(from: NSNumber(value: Double(totalapagarlast)!))
            let valuetotal: Float = Float(totalapagarlast)!
            totalapagar.text = "$ \(String.localizedStringWithFormat("%.2f", valuetotal))"
            
            //let otrokms = numberFormatter.string(from: NSNumber(value: Double(tarifaneeeta)!))
            let valuedos: Float = Float(tarifaneeeta)!
            tafifakms.text = "$ \(String.localizedStringWithFormat("%.2f", valuedos))"
            
            if promolast == "0.0" {
                promo.isHidden = true
                promoshow.isHidden = true
            }else {
                promo.isHidden = false
                promoshow.isHidden = false
                let valuepromo: Float = Float(promolast)!
                promo.text = "$ \(String.localizedStringWithFormat("%.2f", valuepromo))"
            }
            
            if derechopolizad == "" {
                primashow.isHidden = true
                prima.isHidden = true
            }else{
                //let otroprima = numberFormatter.string(from: NSNumber(value: Double(derechopolizad)!))
                let valueprima: Float = Float(derechopolizad)!
                //prima.text = "$ \(otroprima!)"
                prima.text = "$ \(String.localizedStringWithFormat("%.2f", valueprima))"
                prima.isHidden = false
                primashow.isHidden = false
            }
        }
        
        // Do any additional setup after loading the view.
        rowsel = Int(valueToPass)!
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Simolpement dice no aclarar....
    @IBAction func cancel(_ sender: Any) {

        //self.dismiss(animated: true, completion: {
            self.returntoodometer()
        //})

        //open alert to sincronizar
        //openloading(mensaje: "Subiendo información...")

        //cerrando dialog...
        //print("SALIDN3O....1")
        
        //self.alertaloading.dismiss(animated: true, completion: nil)
        /*{
            
            print("SALIDN3O....2")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(myAlert, animated: true, completion: nil)
            
        })*/
        
        /*self.dismiss(animated: true, completion: {

            print("SALIDN3O....2")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(myAlert, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        })*/
    }
    
    //confirma tarifa y enviamos a reportodometer/confirmreport
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
            
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            print(jsonString)
            
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
                        
                        //cerrando dialog...
                        self.alertaloading.dismiss(animated: true, completion: {
                            
                            print("Valoe ------------ devuelro ----------")
                            print(valordevuelto)
                            
                            if valordevuelto == "true" || valordevuelto == "false"{
                                
                                let refreshAlert = UIAlertController(title: "Tu pago se ha realizado", message: "Gracias por ser parte del consumo equitativo.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    do{
                                        //UpdatereportStet from CoreData
                                        //store do core data
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        let context = appDelegate.persistentContainer.viewContext
                                        let requestpolizas = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
                                        
                                        //var fetchRequest = NSFetchRequest(entityName: "LoginData")
                                        requestpolizas.predicate = NSPredicate(format: "nopoliza = %@", arregloPolizas[self.rowsel]["nopoliza"] as! String)
                                        
                                        let test = try context.fetch(requestpolizas)
                                        if test.count == 1
                                        {
                                            let objectUpdate = test[0] as! NSManagedObject

                                            objectUpdate.setValue("12", forKey: "reportstate")
                                            objectUpdate.setValue(odometro, forKey: "lastodometer")

                                            do{
                                                try context.save()
                                            }
                                            catch
                                            {
                                                print(error)
                                            }
                                        }                                        
                                    }catch {
                                        showmessage(message: "Error al actualizar estatus")
                                    }
                                    
                                    print("SALIDN3O....3")
                                    //refreshAlert.dismiss(animated: true, completion: {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let myAlert = storyboard.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                    
                                    self.present(myAlert, animated: true, completion: nil)
                                    //})
                                    //launch second view with data - show table and polizas
                                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                    //self.present(vc, animated: true, completion: nil)
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                            } else {
                                
                            }
                        })
                        
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

                self.alertaloading.dismiss(animated: true, completion: { 
                    
                    print("Valoe ------------ devuelto ----------")
                    print(valordevuelto)
                    
                        let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                            //refreshAlert.dismiss(animated: true, completion: {
                                //launch second view with data - show table and polizas
                                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                //self.present(vc, animated: true, completion: nil)
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myAlert = storyboard.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                
                                self.present(myAlert, animated: true, completion: nil)

                            //})
                        }))
                        
                        /*refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                         
                         //launch second view with data - show table and polizas
                         let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                         self.present(vc, animated: true, completion: nil)
                         }))*/
                        
                        self.present(refreshAlert, animated: true, completion: nil)
                })
            } catch  {
                print("error parsing response from POST on /todos")
                //return 125445
            }
        }
        task.resume()
        
        //DispatchQueue.main.async {
        /*while true {
            if valordevuelto != ""{
                break;
            }
        }*/
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
    
    func returntoodometer(){
        //launch view to confirm odometer
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
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

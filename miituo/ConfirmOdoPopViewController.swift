//
//  ConfirmOdoPopViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 27/04/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit
import CoreData

var odometroanteriorlast = ""
var odometroaactuallast = ""
var kilometrosrecorridoslast = ""
var tarifaporkmlast = ""
var primalast = ""
var basemeslast = ""
var promolast = ""
var totalapagarlast = ""
var derechopolizad = ""
var esperando = ""

var tarifaneeeta = ""

class ConfirmOdoPopViewController: UIViewController {
    
    var rowsel = 0
    
    @IBOutlet var labelodo: UILabel!
    
    //@IBOutlet var labelodometro: UILabel!
    let alertaloading = UIAlertController(title: "Odómetro", message: "Subiendo información...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        //set number odometre
        labelodo.text = numberFormatter.string(from: NSNumber(value: Int(odometro)!))//odometro
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        rowsel = Int(valueToPass)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closePop(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                //self.dismiss(animated: true, completion: {
                    self.returntoodometer()
                //})
            }
        }
    }
    
    @IBAction func sendOdometrofinal(_ sender: Any) {
        
        //dijo que si...enviamos odometro
        if tipoodometro == "first"{
            enviarodometro()
        }else if tipoodometro == "mensual" {
            sendReportOdometer()
        }
    }
    
//enviar odometro first time-----------------------------------------------------------------------
    func enviarodometro(){
        
        //open alert to sincronizar
        openloading(mensaje: "Subiendo información...")
        
        //DispatchQueue.global(qos: .userInitiated).async {
        
         let todosEndpoint: String = "\(ip)ImageProcessing/ConfirmOdometer"
        
         guard let todosURL = URL(string: todosEndpoint) else {
         print("Error: cannot create URL")
         return
         }
         
         var todosUrlRequest = URLRequest(url: todosURL)
         todosUrlRequest.httpMethod = "POST"
         todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
         let newTodo: [String: Any] = ["Type": "5", "Odometer": odometro, "PolicyId":arregloPolizas[self.rowsel]["idpoliza"],"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"]]
            //let newTodo: [String: Any] = ["Type": "5", "Odometer": odometro, "PolicyId":"1","PolicyFolio":"6588023_25042017"]

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
            showmessage(message: receivedTodo["Message"] as! String)
         valordevuelto = receivedTodo["Message"] as! String
         } catch  {
         print("error parsing response from POST on /todos")
         //return
         }
         }
         task.resume()        
         
        //DispatchQueue.main.async {
        while true {
        if valordevuelto != ""{
                break;
            }
        }
        
        //closeloading()
    
        alertaloading.dismiss(animated: true, completion: {
            print("Valoe ------------ devuelro ----------")
            print(valordevuelto)

            //si es true o false => pasa sin problermas y cierra
            if valordevuelto == "true"{
                
                var refreshAlert = UIAlertController(title: "Gracias", message: "Tu información ha sido actualizada.", preferredStyle: UIAlertControllerStyle.alert)
                
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
                            objectUpdate.setValue("true", forKey: "vehiclepie")
                            objectUpdate.setValue("true", forKey: "odometerpie")
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
                    
                    self.launcpolizas()
                }))
                
                self.present(refreshAlert, animated: true)
                
            }else{
                var refreshAlert = UIAlertController(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.launcpolizas()
                    
                }))
                
                self.present(refreshAlert, animated: true)

            }//, completion: nil)
        })
        
         //launch view to confirm odometer
         //let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
         
         //openview
         //self.present(odometerview, animated: true, completion: nil)
            
         //}
        //}
    }

//enviar odometro monthly----------------------------------------------------------------------------
    func sendReportOdometer(){
        let cadena = odometro
        
        // to base64 => yhis is going to be in the thread to send photos
        //let imageData:NSData = UIImagePNGRepresentation(comrimidad)! as NSData
        
        //let strBase64 = comrimidad.base64EncodedString(options: [])
        //open alert to sincronizar
        openloading(mensaje: "Subiendo información...")
        
        let todosEndpoint: String = "\(ip)ReportOdometer/"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //let datainter: [String: Any] = ["PolicyId":"59","PolicyFolio":"884489275","Odometer":cadena,"ClientId":"70"]
        let datainter: [String: Any] = ["PolicyId":arregloPolizas[self.rowsel]["idpoliza"],"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"],"Odometer":cadena,"ClientId":arregloPolizas[self.rowsel]["idcliente"]]
        let newTodo: [String: Any] = ["Type": "1","ImageItem":datainter]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        //let semaphore = DispatchSemaphore(value: 0);
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
                    //showmessage(message: meessage as! String)
                    valordevuelto = receivedTodo["Message"] as! String
                    odometro = "no"
                    
                    self.alertaloading.dismiss(animated: true, completion: {
                        var refreshAlert = UIAlertController(title: "Atención", message: "El odometro reportado no puede ser menor al registrado anteriormente", preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                            self.dismiss(animated: true, completion: {
                                self.returntoodometer()
                            })
                            
                            //self.launcpolizas()
                            
                        }))
                        
                        self.present(refreshAlert, animated: true)
                    })
                }else{
                    
                    flag = true

//---------------------------------------- receive info from WS and show bill to pay------------------
                    //DispatchQueue.main.async {
                    while true {
                        if valordevuelto != ""{
                            break;
                        }
                    }
                    
                    //closeloading()
                    
                    if valordevuelto == "El odometro reportado no puede ser menor al registrado anteriormente" {
                        self.alertaloading.dismiss(animated: true, completion: {
                            var refreshAlert = UIAlertController(title: "Atención", message: "El odometro reportado no puede ser menor al registrado anteriormente", preferredStyle: UIAlertControllerStyle.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.dismiss(animated: true, completion: {
                                    self.returntoodometer()
                                })
                            }))
                            self.present(refreshAlert, animated: true)
                        })
                    }
                    else {
                    
                        //Dismiss alertdialog....
                        self.alertaloading.dismiss(animated: true, completion: {
                            
                            let totalmestemp = receivedTodo["Amount"] as! Float
                            totalapagarlast = String(totalmestemp)
                            //datareturned["odohoy"] = String(describing:totalmes)
                            
                            /*Recuperamos valores de fee,promo y derecho*/
                            let tarifafijames = receivedTodo["Parameters"] as! NSArray
                            print("Numero de datos en tarifa mes: \(tarifafijames.count)")
                        
                            if tarifafijames.count == 3{
                                
                                let tarifakmtemp = (tarifafijames[0] as AnyObject).value(forKey: "Amount") as! Float
                                basemeslast = String(tarifakmtemp)
                                let dereccc = (tarifafijames[1] as AnyObject).value(forKey: "Amount") as! Float
                                derechopolizad = String(dereccc)
                                let promolasttemp = (tarifafijames[2] as AnyObject).value(forKey: "Amount") as! Float
                                promolast = String(promolasttemp)
                                
                            } else if tarifafijames.count == 2{
                                
                                let tarifakmtemp = (tarifafijames[0] as AnyObject).value(forKey: "Amount") as! Float
                                basemeslast = String(tarifakmtemp)
                                let promolasttemp = (tarifafijames[1] as AnyObject).value(forKey: "Amount") as! Float
                                promolast = String(promolasttemp)
                            }
                            
                            /*Recuperamos odometro anteruo y actual registrado*/
                            let odometros = receivedTodo["FormulaChilds"] as! NSArray
                            let datainicial = (odometros[0] as! NSDictionary)

                            let datosodometros = datainicial["FormulaChilds"] as! NSArray
                            let masdatosodo = datosodometros[0] as! NSDictionary
                            
                            let ahorasiodos = masdatosodo["Parameters"] as! NSArray
                            let odometrofinalnuevo = (ahorasiodos[0] as AnyObject).value(forKey: "Amount") as! Int
                            let odometrofinalanterior = (ahorasiodos[1] as AnyObject).value(forKey: "Amount") as! Int

                            odometroanteriorlast = String(odometrofinalanterior)
                            odometroaactuallast = String(odometrofinalnuevo)
                            
                            /*Recuepramos kms recorridos*/
                            let cantidadderecorridos = masdatosodo["Amount"] as! Int
                            kilometrosrecorridoslast = String(cantidadderecorridos)
                            
                            /*Recuperamos tarifa fija....*/
                            let tarifaarreglo = datainicial["Parameters"] as! NSArray
                            let feefinal = (tarifaarreglo[0] as AnyObject).value(forKey: "Amount") as! Double
                            tarifaporkmlast = String(feefinal)
                            
                            /*Tarfia neta*/
                            let tarifaneta = datainicial["Amount"] as! Float
                            tarifaneeeta = String(tarifaneta)

                            //let masdatos = receivedTodo["FormulaChilds"] as! NSArray
                            //let datosneta = masdatos[0] as! NSArray
                            
                            print("tarifafjia: \(tarifaporkmlast)")
                            print("promo: \(promolast)")
                        
                            //update values to send to the cystom alert
                            //odometro = String(describing:promocion)
                            odometro = cadena
                            
                            //semaphore.signal();
                        
                            //DispatchQueue.global(qos: .userInitiated).async { // 1
                            //let overlayImage = self.faceOverlayImageFromImage(self.image)
                            //DispatchQueue.main.async { // 2
                            
                            if odometro != "no" {
                                //show alert with data
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
                                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        //}
                        })
                    }
                }
                
            } catch  {
                print("error parsing response from POST on /todos")
                //return 125445
            }
        }
        
        task.resume()
        //semaphore.wait()
        //let resut = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: 2000000000))
        //print("Semaforo:\(resut)")
        
        print("Out of here")
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
    
    func launcpolizas(){
        //launch view to confirm odometer
        let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        
        //openview
        self.present(odometerview, animated: true, completion: nil)
    }
    
    func returntoodometer(){
        //launch view to confirm odometer
        /*let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
        
        //openview
        self.present(odometerview, animated: true, completion: nil)
        */
        
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

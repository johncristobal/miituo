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

var fiva = ""
var ivait = ""
var ivaderecho = ""

var lastvalordev = ""

class ConfirmOdoPopViewController: UIViewController {
    
    var rowsel = 0
    
    @IBOutlet var labelodo: UILabel!
    
    //@IBOutlet var labelodometro: UILabel!
    let alertaloadingodo = UIAlertController(title: "Odómetro", message: "Subiendo información...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        //set number odometre
        labelodo.text = numberFormatter.string(from: NSNumber(value: Int(odometro)!))//odometro
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        rowsel = Int(valueToPass)!
        
        odometroanteriorlast = ""
        odometroaactuallast = ""
        kilometrosrecorridoslast = ""
        tarifaporkmlast = ""
        primalast = ""
        basemeslast = ""
        promolast = ""
        totalapagarlast = ""
        derechopolizad = ""
        esperando = ""
        
        tarifaneeeta = ""
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
        //Para cancelacion y ajuste es el mismo flujo
        if tipoodometro == "first"{
            enviarodometro()
        }else if tipoodometro == "mensual" {
            sendReportOdometer()
        }
        else if tipoodometro == "cancela" {
            ajustaReportOdometer()
        }
        else if tipoodometro == "ajuste" {
            ajustaReportOdometer()
        }
    }

//***************************Function updatetcasification*********************************************
    func upstatecasification()
    {
        /// ----------- send confirmreport ------------ ///
        //Para actualizar el campo de Id_Estatus de la tabla de Clientes_Ticket
        let todosEndpoint: String = "\(ip)UpStateCasification"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let newTodo: [String: Any] = ["Id":idticket,"sTiket":7,"GodinName":"App","GodynSolution":""]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            print("CASIFICATION \(jsonString)")
            
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) { (responseData, response, error) in

            /*guard error == nil else {
                print("error calling POST on /todos/1")
                return
            }*/
            /*guard let responseData = data else {
                print("Error: did not receive data")
                return
            }*/
            if let httpResponse = response as? HTTPURLResponse
            {
                print("error \(httpResponse.statusCode)")
                print("error \(httpResponse.description)")

                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        print("Valor de retorno: \(str)")
                        valordevuelto = str
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                } else {
                    // parse the result as JSON, since that's what the API provides
                     do {
                         guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
                         options: []) as? [String: Any] else {
                            print("Could not get JSON from responseData as dictionary")
                            return
                         }
                         print("The todo is: " + receivedTodo.description)
                         
                         self.alertaloadingodo.dismiss(animated: true, completion: {
                         
                             print("Valoe ------------ devuelto ----------")
                             print(valordevuelto)
                             
                             let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                             
                             refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                             
                             self.launcpolizas()
                             }))
                             
                             self.present(refreshAlert, animated: true, completion: nil)
                         })
                     } catch  {
                        print("error parsing response from POST on /todos")
                     }
                }
            }
        }
        task.resume()
    }
    
//***************************update dometer tkcet***************************************
    func ticketupload(){

        //Se actualiza el  odometro en la tabla de Clientes ticket en el campo
        let todosEndpoint: String = "\(ip)Ticket/"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //let newTodo: [String: Any] = ["Celphone":"5534959778","Id":"0","Token":"aaaaaaaaaaa"]
        let newTodo: [String: Any] = ["OdomCorrect": 0, "OdomMoment": odometro, "idTicket":idticket, "idPolicy":arregloPolizas[self.rowsel]["nopoliza"]]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
            print("Ticket json: \(jsonString)")
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) { (responseData, response, error) in
            /*guard error == nil else {
                print("error calling POST on /todos/1")
                return
            }*/
            /*guard let responseData = data else {
                print("Error: did not receive data")
                return
            }*/
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                print("error \(httpResponse.description)")
                //print("error \(httpResponse.)")
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        print("Valor de retorno: \(str)")
                        valordevuelto = str
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                } else {
                     // parse the result as JSON, since that's what the API provides
                     do {
                         guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
                         options: []) as? [String: Any] else {
                            print("Could not get JSON from responseData as dictionary")
                            return
                         }
                         print("The todo is: " + receivedTodo.description)
                         
                         self.alertaloadingodo.dismiss(animated: true, completion: {
                            
                             print("Valoe ------------ devuelto ----------")
                             print(valordevuelto)
                             
                             let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                             
                             refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                             
                             self.launcpolizas()
                             }))
                             
                             self.present(refreshAlert, animated: true, completion: nil)
                         })
                     } catch  {
                        print("error parsing response from POST on /todos")
                     }
                }
            }
        }
        task.resume()
    }

//***************************update status poliza*********************************************
    func updatestatus(){
        
        let todosEndpoint: String = "\(ip)Policy/UpdatePolicyStatusReport/\(arregloPolizas[rowsel]["idpoliza"] as! String)/12"

        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        /*let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
            print("LAast json - json: \(jsonString)")
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }*/
        
        let session = URLSession.shared
        let loadTask = session.dataTask(with: todosUrlRequest) { (responseData,response,error) in
            
            /*guard error == nil else {
                print("error calling POST on /todos/1")
                return
            }*/
            /*guard let responseData = data else {
                print("Error: did not receive data")
                return
            }*/
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                print("error \(httpResponse.description)")
                //print("error \(httpResponse.)")
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        print("Valor de retorno: \(str)")
                        lastvalordev = str
                        
                        DispatchQueue.main.async {

                        self.alertaloadingodo.dismiss(animated: true, completion: {
                            print("Valor ------------ devuelto ----------")
                            print(lastvalordev)
                            
                            //si es true o false => pasa sin problermas y cierra
                            if lastvalordev == "true"{
                                
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
                                
                                let refreshAlert = UIAlertController(title: "Gracias", message: "Información del odómetro actualizada.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.launcpolizas()
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                            }
                            else
                            {
                                var refreshAlert = UIAlertController(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.launcpolizas()
                                }))
                                
                                self.present(refreshAlert, animated: true)
                            }
                        })
                        }
                        
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                }//sTATUS DIFerente a 200
                else {
                    // parse the result as JSON, since that's what the API provides
                     do {
                     guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,options: []) as? [String: Any] else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                     }
                     print("The todo is: " + receivedTodo.description)
                     
                     self.alertaloadingodo.dismiss(animated: true, completion: {
                     
                         print("Valoe ------------ devuelto ----------")
                         print(lastvalordev)
                         
                         let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                         
                         refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                         
                             self.launcpolizas()
                         }))
                         
                         self.present(refreshAlert, animated: true, completion: nil)
                     })
                     
                     } catch  {
                        print("error parsing response from POST on /todos")
                     }
                }
            }
         }
         loadTask.resume()
        
         /*while true {
            if lastvalordev != ""{
                break;
            }
         }*/
    }
    
//***************************Function to send token to ws*********************************************
    func ajustaReportOdometer(){

        //open alert to sincronizar
        openloading(mensaje: "Subiendo información...")
        
        //servicio para actualiza status en UpStateCasification------------------------------------
        upstatecasification()   //ok
        ticketupload()
        updatestatus()
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

         let jsonTodo: Data
         do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
            print("Enviando odometro json: \(jsonString)")

         } catch {
             print("Error: cannot create JSON from todo")
             return
         }
         
         let session = URLSession.shared
         
         let task = session.dataTask(with: todosUrlRequest) {
         (responseData, response, error) in

         /*guard error == nil else {
            print("error calling POST on /todos/1")
            print(error)
            return
         }*/
         /*guard let responseData = data else {
             print("Error: did not receive data")
             return
         }*/
            
         if let httpResponse = response as? HTTPURLResponse {
             print("error \(httpResponse.statusCode)")
             print("error \(httpResponse.description)")
             //print("error \(httpResponse.)")
             if httpResponse.statusCode == 200 {
                 if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                    print("Valor de retorno: \(str)")
                    valordevuelto = str
                    
                    DispatchQueue.main.async {
                    self.alertaloadingodo.dismiss(animated: true, completion: {
                        print("Valor ------------ devuelto ----------")
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
                            DispatchQueue.main.async {

                            var refreshAlert = UIAlertController(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertControllerStyle.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.launcpolizas()
                            }))
                            
                            self.present(refreshAlert, animated: true)
                            }
                            
                        }//, completion: nil)
                    })
                    }
                 } else {
                    print("not a valid UTF-8 sequence")
                 }
             }else {
                // parse the result as JSON, since that's what the API provides
                 do {
                 guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
                 options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                 }
                 print("The todo is: " + receivedTodo.description)
                    DispatchQueue.main.async {

                    var refreshAlert = UIAlertController(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        
                        self.launcpolizas()
                    }))
                    
                    self.present(refreshAlert, animated: true)
                    }
                 //print("The todo is message:  \(receivedTodo["Message"] as! String)")
                 //showmessage(message: receivedTodo["Message"] as! String)
                 //valordevuelto = receivedTodo["Message"] as! String
                 } catch  {
                    print("error parsing response from POST on /todos")
                 }
            }
         }
         }
         task.resume()        
         
        //DispatchQueue.main.async {
        /*while true {
        if valordevuelto != ""{
                break;
            }
        }*/
        
         //closeloading()
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
            
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            print("Json reporte mensual \(jsonString)")
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        //let semaphore = DispatchSemaphore(value: 0);
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) { (responseData, response, error) in
            /*guard error == nil else {
                print("error calling POST on /todos/1")
                return
            }*/
            /*guard let responseData = data else {
                print("Error: did not receive data")
                return
            }*/
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                //print("error \(httpResponse.description)")
                //print("error \(httpResponse.)")
                if httpResponse.statusCode == 200 {
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        print("Valor de retorno odometro: \(str)")
                        valordevuelto = str
                        
                        DispatchQueue.main.async {

                            // parse the result as JSON, since that's what the API provides
                            do {
                                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
                                                                                          options: []) as? [String: Any] else {
                                                                                            print("Could not get JSON from responseData as dictionary")
                                                                                            return
                                }
                        //Dismiss alertdialog....
                        self.alertaloadingodo.dismiss(animated: true, completion: {
                            
                            let totalmestemp = receivedTodo["Amount"] as! Float
                            totalapagarlast = String(totalmestemp)
                            //datareturned["odohoy"] = String(describing:totalmes)
                            
                            /*Recuperamos valores de fee,promo y derecho*/
                            let tarifafijames = receivedTodo["Parameters"] as! NSArray
                            print("Numero de datos en tarifa mes: \(tarifafijames.count)")
                            
                            if tarifafijames.count == 12{
                                let tarifakmtemp = (tarifafijames[0] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let dereccc = (tarifafijames[1] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let promolasttemp = (tarifafijames[2] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let feefinal = (tarifafijames[3] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let odometrofinalnuevo = (tarifafijames[4] as AnyObject).value(forKey: "Amount") as! Int
                                let odometrofinalanterior = (tarifafijames[5] as AnyObject).value(forKey: "Amount") as! Int
                                
                                let cantidadderecorridos = (tarifafijames[6] as AnyObject).value(forKey: "Amount") as! Int
                                
                                let tarifaneta = (tarifafijames[8] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let ivafee = (tarifafijames[9] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let ivaneta = (tarifafijames[10] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let ivadp = (tarifafijames[11] as AnyObject).value(forKey: "Amount") as! Double
                                
                                derechopolizad = String(dereccc + ivadp)
                                basemeslast = String(tarifakmtemp + ivafee)
                                promolast = String(promolasttemp)
                                tarifaporkmlast = String(feefinal)
                                
                                odometroanteriorlast = String(odometrofinalanterior)
                                odometroaactuallast = String(odometrofinalnuevo)
                                kilometrosrecorridoslast = String(cantidadderecorridos)
                                
                                tarifaneeeta = String(tarifaneta + ivaneta)
                                
                                fiva = String(ivafee)
                                ivait = String(ivaneta)
                                ivaderecho = String(ivadp)
                                
                            } else if tarifafijames.count == 10{
                                let tarifakmtemp = (tarifafijames[0] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let promolasttemp = (tarifafijames[1] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let feefinal = (tarifafijames[2] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let odometrofinalnuevo = (tarifafijames[3] as AnyObject).value(forKey: "Amount") as! Int
                                let odometrofinalanterior = (tarifafijames[4] as AnyObject).value(forKey: "Amount") as! Int
                                
                                let cantidadderecorridos = (tarifafijames[5] as AnyObject).value(forKey: "Amount") as! Int
                                
                                let tarifaneta = (tarifafijames[7] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let ivafee = (tarifafijames[8] as AnyObject).value(forKey: "Amount") as! Double
                                
                                let ivaneta = (tarifafijames[9] as AnyObject).value(forKey: "Amount") as! Double
                                
                                //derechopolizad = String(dereccc + ivadp)
                                basemeslast = String(tarifakmtemp + ivafee)
                                promolast = String(promolasttemp)
                                tarifaporkmlast = String(feefinal)
                                
                                odometroanteriorlast = String(odometrofinalanterior)
                                odometroaactuallast = String(odometrofinalnuevo)
                                kilometrosrecorridoslast = String(cantidadderecorridos)
                                
                                tarifaneeeta = String(tarifaneta + ivaneta)
                                
                                fiva = String(ivafee)
                                ivait = String(ivaneta)
                                //ivaderecho = String(ivadp)
                            }
                            
                            /*
                             //Recuperamos odometro anteruo y actual registrado
                             let odometros = receivedTodo["FormulaChilds"] as! NSArray
                             let datainicial = (odometros[0] as! NSDictionary)
                             
                             let datosodometros = datainicial["FormulaChilds"] as! NSArray
                             let masdatosodo = datosodometros[0] as! NSDictionary
                             
                             let ahorasiodos = masdatosodo["Parameters"] as! NSArray
                             let odometrofinalnuevo = (ahorasiodos[0] as AnyObject).value(forKey: "Amount") as! Int
                             let odometrofinalanterior = (ahorasiodos[1] as AnyObject).value(forKey: "Amount") as! Int
                             
                             odometroanteriorlast = String(odometrofinalanterior)
                             odometroaactuallast = String(odometrofinalnuevo)
                             
                             //Recuepramos kms recorridos
                             let cantidadderecorridos = masdatosodo["Amount"] as! Int
                             kilometrosrecorridoslast = String(cantidadderecorridos)
                             
                             //Recuperamos tarifa fija....
                             let tarifaarreglo = datainicial["Parameters"] as! NSArray
                             let feefinal = (tarifaarreglo[0] as AnyObject).value(forKey: "Amount") as! Double
                             tarifaporkmlast = String(feefinal)
                             
                             //Tarfia neta
                             let tarifaneta = datainicial["Amount"] as! Float
                             tarifaneeeta = String(tarifaneta)
                             
                             print("tarifafjia: \(tarifaporkmlast)")
                             print("promo: \(promolast)")
                             
                             //update values to send to the cystom alert
                             //odometro = String(describing:promocion)
                             odometro = cadena
                             */
                            
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
                            } catch  {
                                print("error parsing response from POST on /todos")
                                //return 125445
                            }
                        }
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                } else {
                    //showmessage(message: "El odometro debe ser mayor al anterior")
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
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
                            
                            DispatchQueue.main.async {
                                
                                self.alertaloadingodo.dismiss(animated: true, completion: {
                                    var refreshAlert = UIAlertController(title: "Atención", message: valordevuelto, preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        //self.dismiss(animated: true, completion: {
                                            self.returntoodometer()
                                        //})
                                    }))
                                    self.present(refreshAlert, animated: true)
                                })
                            }
                        }else{
                            
                            //---------------------------------------- receive info from WS and show bill to pay------------------
                            //DispatchQueue.main.async {
                            /*while true {
                             if valordevuelto != ""{
                             break;
                             }
                             }*/
                            
                            //closeloading()
                            
                            DispatchQueue.main.async {

                            self.alertaloadingodo.dismiss(animated: true, completion: {
                                var refreshAlert = UIAlertController(title: "Atención", message: "Encontramos un detalle al momento de reportar. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.dismiss(animated: true, completion: {
                                        self.launcpolizas()
                                    })
                                }))
                                self.present(refreshAlert, animated: true)
                            })
                            }
                        }
                    } catch  {
                        print("error parsing response from POST on /todos")
                        //return 125445
                    }
                }
            }
        }
        
        task.resume()
        //semaphore.wait()
        //let resut = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: 2000000000))
        //print("Semaforo:\(resut)")
        
        print("Out of here")
    }

//loading----------------------------------------------------------------------------
    func openloading(mensaje: String){
        
        alertaloadingodo.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alertaloadingodo.view.addSubview(loadingIndicator)
        present(alertaloadingodo, animated: true, completion: nil)
    }

//elaunch polizas----------------------------------------------------------------------------
    func launcpolizas(){
        //launch view to confirm odometer

        /*let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        //openview
        self.present(odometerview, animated: true, completion: nil)
         */
        actualizar = "1"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        //launch second view with data - show table and polizas
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(myAlert, animated: true, completion: nil)
    }
    
//regresa a doometro----------------------------------------------------------------------------
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
}

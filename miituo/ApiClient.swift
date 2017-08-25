//
//  ApiClient.swift
//  devmiituo
//
//  Created by vera_john on 04/04/17.
//  Copyright © 2017 VERA. All rights reserved.


import UIKit
import Foundation
import CoreData

//let ip = "http://192.168.1.31:1000/api/"

//let ip = "http://192.168.1.109:1003/api/"

let ip = "http://miituodev.sytes.net:1001/api/" //DEV

//let ip = "http://miituodev.sytes.net:1003/api/"   //QAS

//let ip = "https://miituo.com/api/api/"   //PROD

var idticket = ""

var jsoncorrecto = "1"

//var json:AnyObject?

/*********************** launch polizas***************************************************/
func launchpolizas(vista: UIViewController){
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
    
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    //launch second view with data - show table and polizas
    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
    vista.present(myAlert, animated: true, completion: nil)
}

//*******************Function to get data with the celphone*********************************************
func getJson(telefon:String, vistafrom: UIViewController,dedonde: String){
    
    print("getjson: \(telefon)")
    
    //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
    // Put your code which should be executed with a delay here
    
    //I dont have json here...just call WS into thread
    if conexion == "0" {
        showmessage(message: "Sin conexión. Intente más tarde.")
        DispatchQueue.main.async {
            alertaloading?.dismiss(animated: true, completion: {
            })
        }
    }
    else{
        
        //use thread to async this action
        let url = URL(string: "\(ip)InfoClientMobil/Celphone/"+telefon)!
        
        let session = URLSession.shared
        let loadTask = session.dataTask(with: url){(data,response,error) in
            if error != nil {
                showmessage(message: "Error de conexión. Intenta más tarde.")
                //After for to save polizas....
                DispatchQueue.main.async {
                    alertaloading?.dismiss(animated: true, completion: {

                        if let token = UserDefaults.standard.value(forKey: "sesion") {
                            
                            //DispatchQueue.main.async {
                            //close loading view
                            launchpolizas(vista: vistafrom)
                            //}
                        }
                        else
                        {
                            //get data from WS
                            //getSms(telefon: telefon);
                            
                            //DispatchQueue.main.async {
                            //close loading view
                            //launchtoken(v: vistafrom)
                            //}
                        }
                    })
                }

            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                    print("error \(httpResponse.description)")
                    
                    if httpResponse.statusCode == 200{
                        if let str = String(data: data!, encoding: String.Encoding.utf8) {
                            print("Valor de retorno: \(str)")
                            valordevuelto = str
                            
                            if str == "null"{
                                DispatchQueue.global(qos: .userInitiated).async {
                                    //DispatchQueue.main.async {
                                    alertaloading?.dismiss(animated: true, completion: {
                                        //launchpolizas(vista: vistafrom)
                                    })
                                }
                            }
                            
                            UserDefaults.standard.setValue(telefon, forKey: "celular")
                            
                            //------------------------------recover data from WS
                            if let urlContent = data{
                                do {
                                    let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                    
                                    print("Imprimendo jJSON")
                                    //print(json)
                                    
                                    guard let temp = json.value(forKey: "Client") else{
                                        //print(temp)
                                        print("error")
                                        
                                        DispatchQueue.global(qos: .userInitiated).async {
                                            //DispatchQueue.main.async {
                                            alertaloading?.dismiss(animated: true, completion: {
                                                //launchpolizas(vista: vistafrom)
                                                //Alerta con mensaje de error
                                                let refreshAlert = UIAlertController(title: "Atención", message: "Error al actualizar información. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                                                
                                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                    
                                                    //})
                                                }))
                                                
                                                vistafrom.present(refreshAlert, animated: true, completion: nil)
                                            })
                                        }
                                        return
                                    }
                                    
                                    tienepolizas = "si"

                                    DispatchQueue.main.async() {
                                        saveCoreData(json: json, telefon: telefon)
                                    }
                                    
                                    DispatchQueue.main.async {
                                        //After for to save polizas....
                                        alertaloading?.dismiss(animated: true, completion: {
                                            //launchpolizas(vista: vistafrom)
                                            if let token = UserDefaults.standard.value(forKey: "sesion") {
                                                
                                                //DispatchQueue.main.async {
                                                //close loading view
                                                launchpolizas(vista: vistafrom)
                                                //}
                                            }
                                            else
                                            {
                                                //get data from WS
                                                getSms(telefon: telefon);
                                                
                                                //DispatchQueue.main.async {
                                                //close loading view
                                                launchtoken(v: vistafrom)
                                                //}
                                            }
                                        })
                                    }
                                    
                                } catch {
                                    showmessage(message: "Error en JSON datos polizas.")
                                }
                                
                            }else{
                                DispatchQueue.main.async {
                                    showmessage(message: "Sin conexión a Internet. Actualice información más tarde.")
                                }
                            }
                            
                        } else {
                            print("not a valid UTF-8 sequence")
                        }
                    }else{
                        //catch error to log
                        // parse the result as JSON, since that's what the API provides
                        do {
                            guard let receivedTodo = try JSONSerialization.jsonObject(with: data!,
                                                                                      options: []) as? [String: Any] else {
                                                                                        print("Could not get JSON from responseData as dictionary")
                                                                                        return
                            }
                            print("The todo is: " + receivedTodo.description)
                            jsoncorrecto = "0"
                            //Disparamos error y regresamos a polzias
                            //Disparamos error y regresamos a polzias
                            DispatchQueue.main.async {
                                let mess = receivedTodo["Message"] as! String
                                
                                if mess.contains("null")
                                {
                                    alertaloading?.dismiss(animated: true, completion: {
                                        
                                        let prefs = UserDefaults.standard
                                        prefs.removeObject(forKey:"tutoya")
                                        prefs.removeObject(forKey:"tutoya")
                                        prefs.removeObject(forKey:"celular")
                                        
                                        if dedonde == "sync"{
                                            
                                            //Alerta con mensaje de error
                                            let refreshAlert = UIAlertController(title: "Atención", message: "No tienes pólizas registradas. Vuelve a cotizar.", preferredStyle: UIAlertControllerStyle.alert)
                                            
                                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                
                                                //})
                                            }))
                                            
                                            vistafrom.present(refreshAlert, animated: true, completion: nil)
                                            
                                        }else{
                                            //open mainactivity
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let myAlert = storyboard.instantiateViewController(withIdentifier: "flash") as! SplashViewController
                                            
                                            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                            
                                            //launch second view with data - show table and polizas
                                            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                            vistafrom.present(myAlert, animated: true, completion: nil)
                                        }
                                        
                                    })
                                }
                                else{
                                    showmessage(message: mess)
                                    
                                    alertaloading?.dismiss(animated: true, completion: {
                                        if let token = UserDefaults.standard.value(forKey: "sesion") {
                                            //DispatchQueue.main.async {
                                            //close loading view
                                            //alertaloading?.dismiss(animated: true, completion: {
                                            if let token = UserDefaults.standard.value(forKey: "sesion") {
                                                
                                                //close loading view
                                                //alertaloading?.dismiss(animated: true, completion: {
                                                launchpolizas(v: vistafrom)
                                                //})
                                            }
                                            else
                                            {
                                                //get data from WS
                                                getSms(telefon: telefon);
                                                
                                                //close loading view
                                                //alertaloading?.dismiss(animated: true, completion: {
                                                launchtoken(v: vistafrom)
                                                //})
                                            }
                                            //})
                                            //}
                                        }
                                        else
                                        {
                                            //get data from WS
                                            getSms(telefon: telefon);
                                            
                                            DispatchQueue.main.async {
                                                //close loading view
                                                alertaloading?.dismiss(animated: true, completion: {
                                                    launchtoken(v: vistafrom)
                                                })
                                            }
                                        }
                                    })
                                }
                            }
                        } catch  {
                            print("error parsing response from POST on /todos")
                            return
                        }
                    }
                }
            }
        }
        loadTask.resume()
    }
    //})
}

/*********************** launch polizas***************************************************/
func saveCoreData(json: AnyObject, telefon: String){

    //store do core data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateMOC.parent = context

    privateMOC.perform {
    
        do{
        //let requesst = NSFetchRequest<NSFetchRequestResult>(entityName:"Users",inManagedObjectContext: privateMOC)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let requestpolizas = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
        let requestcarritos = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehiculos")
        
        //Delete items from CoreData and get again********************************************************
        let fetch = NSBatchDeleteRequest(fetchRequest: request)
        let result = try context.execute(fetch)
        let fetchpol = NSBatchDeleteRequest(fetchRequest: requestpolizas)
        let resultpol = try context.execute(fetchpol)
        let fetchpolcar = NSBatchDeleteRequest(fetchRequest: requestcarritos)
        let resultpolcar = try context.execute(fetchpolcar)
        print(result)
        print(resultpol)
        print(resultpolcar)
        
        //get data from client....
        let cliente = json.value(forKey: "Client") as! NSArray
        //print(cliente)
        
        //forach to get all tjhe polizas here :) ***************************************
        for index in 0...cliente.count-1{
            
            //let cli = cliente[0] as! NSDictionary
            let cli = cliente[index] as! NSDictionary
            
            //get client y save data
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: privateMOC)
            let idcliente = cli.value(forKey: "Id") as! Int
            print("from here: \(idcliente)")
            newUser.setValue(idcliente, forKey: "id")
            //managedObject Core Data
            //let noolizasss = (poli["NoPolicy"] as! String).description
            let lastnma = (cli["LastName"] as! String).description
            newUser.setValue(lastnma, forKey: "lastname")
            let motherna = (cli["MotherName"] as! String).description
            newUser.setValue(motherna, forKey: "mothername")
            let nameee = (cli["Name"] as! String).description
            newUser.setValue(nameee, forKey: "name")
            let tokene = ""//(cli["Token"] as! String).description
            newUser.setValue(tokene, forKey: "token")
            //let celppp = String(describing: (cli["Celphone"]))
            newUser.setValue(telefon, forKey: "celphone")
            
            do {
                try privateMOC.save()
                context.performAndWait{
                    do {
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                print("Saved client")
            } catch {
                showmessage(message: "Error al guardar datos")
            }
            
            //get data from client....
            let polizas = json.value(forKey: "Policies") as! NSArray
            print("numero de polizas retornadas: \(polizas.count)")
            
            //for index in 0...polizas.count-1{
            let poli = polizas[index] as! NSDictionary
            
            //print("poliza: \(poli)")
            //now the turn os for polizas
            let newPoli = NSEntityDescription.insertNewObject(forEntityName: "Polizas", into: privateMOC)
            
            let noolizasss = (poli["NoPolicy"] as! String).description
            //get poliza to sms token
            //polizaparasms = noolizasss
            newPoli.setValue(noolizasss, forKey: "nopoliza")
            
            //fecha...
            let dateString = (poli["LimitReportDate"] as! String).description
            
            let dateFormatter = DateFormatter()
            let localeStr = "us" // this will succeed
            dateFormatter.locale = NSLocale(localeIdentifier: localeStr) as Locale!
            
            if dateString.contains(".") {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            }else{
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            }
            
            let s = dateFormatter.date(from:dateString)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateStringfin = dateFormatter.string(from:s!)
            print("fecha linite: \(dateStringfin)")
            newPoli.setValue(s, forKey: "limitefecha")
            
            print("idcliente\(idcliente)")
            newPoli.setValue(idcliente, forKey: "idcliente")
            
            //managedObject Core Data
            let insu = poli["InsuranceCarrier"] as! NSDictionary
            newPoli.setValue(insu["Name"], forKey: "insurance")
            
            let stringodo = (poli["LastOdometer"] as! Int).description
            newPoli.setValue(String(stringodo), forKey: "lastodometer")
            
            let idpolizzz = (poli["Id"] as! Int).description
            polizaparasms = idpolizzz
            newPoli.setValue(idpolizzz, forKey: "idpoliza")
            
            let plizasid = poli["NoPolicy"]
            let odometerbool = (poli["HasOdometerPicture"] as! Bool).description
            //let stringodometer:String = String(odometerbool.description)
            newPoli.setValue(odometerbool, forKey: "odometerpie")
            let vehiclepool = (poli["HasVehiclePictures"] as! Bool).description
            newPoli.setValue(vehiclepool, forKey: "vehiclepie")
            let rattt = String(describing: (poli["Rate"]))
            newPoli.setValue(rattt, forKey: "rate")
            let reportsta = (poli["ReportState"] as! Int).description
            newPoli.setValue(reportsta, forKey: "reportstate")
            
            //with this let we cna get dat from the vehicle
            let vehiculo = poli["Vehicle"] as! NSDictionary
            do {
                
                try privateMOC.save()
                context.performAndWait{
                    do {
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                print("Saved poliza \(noolizasss)")
                
            } catch {
                showmessage(message: "Error al guardar datos")
            }
            
            //now the turn os for polizas
            let newCar = NSEntityDescription.insertNewObject(forEntityName: "Vehiculos", into: privateMOC)
            //get data from client....
            //let polizas = json.value(forKey: "Policies") as! NSArray
            //print(vehiculo)
            let vei = vehiculo//[0] as! NSDictionary
            
            newCar.setValue(plizasid, forKey: "idpolizas")
            //managedObject Core Data
            let brand = vei["Brand"] as! NSDictionary
            newCar.setValue(brand["Description"], forKey: "brand")
            
            let capac = String(describing:vei["Capacity"])
            newCar.setValue(capac, forKey: "capacidad")
            newCar.setValue(vei["Color"], forKey: "color")
            
            let descrii = vei["Description"] as! NSDictionary
            newCar.setValue(descrii["Description"], forKey: "descripcion")
            
            let modell = vei["Model"] as! NSDictionary
            let modelito = (modell["Model"] as! Int).description
            newCar.setValue(modelito, forKey: "model")
            newCar.setValue(vei["Plates"], forKey: "plates")
            
            let subtyoe = vei["Subtype"] as! NSDictionary
            newCar.setValue(subtyoe["Description"], forKey: "subtype")
            
            let tyype = vei["Type"] as! NSDictionary
            newCar.setValue(tyype["Description"], forKey: "type")
            
            let idc = String(describing:vei["Id"])
            newCar.setValue(idc, forKey: "idcarro")
            
            do {
                try privateMOC.save()
                context.performAndWait{
                    do {
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                print("Saved vehicle")
                
            } catch {
                showmessage(message: "Error al guardar datos")
            }
            
            //lest try get ticket
            if let tick = poli["Tickets"] as? NSNull{
                print("null")
            }else{
                let ticket = poli["Tickets"] as! NSArray //as! NSArray
                
                if ticket.count == 0{
                    print("null")
                }else{
                    let idticketdic = ticket[0] as! NSDictionary
                    
                    //print(idticketdic["Id"])
                    if reportsta == "15" || reportsta == "14" {
                        idticket = (idticketdic["Id"] as! Int).description
                        print(idticket)
                    }
                }
            }
        }
        }catch {
            showmessage(message: "Tuvimos un problema al guardar. Intente más tarde.")
        }
    }
}

/*********************** launch polizas***************************************************/
func launchpolizas(v: UIViewController){
    //launch second view with data - show table and polizas
    /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
     self.present(vc, animated: true, completion: nil)*/
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
    
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    //launch second view with data - show table and polizas
    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
    v.present(myAlert, animated: true, completion: nil)
    //self.dismiss(animated: true, completion: nil)
    
}

/*********************** launch token***************************************************/
func launchtoken(v: UIViewController){
    //launch second view with data - show table and polizas
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let vc = storyboard.instantiateViewController(withIdentifier: "smsview") as! TokenSmsViewController
    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    v.present(vc, animated: true, completion: nil)
    
    //self.dismiss(animated: true, completion: nil)
}

//*******************Function to get data with the celphone*********************************************
func getSms(telefon:String){
    
    if jsoncorrecto != "0"
    {
        let url = URL(string: "\(ip)TemporalToken/GetTemporalTokenPhone/"+telefon+"/"+polizaparasms!+"/AppToken")!
        let session = URLSession.shared;
        let loadTask = session.dataTask(with: url){(data,response,error) in
            if error != nil{
                showmessage(message: "Error de conexiòn... \(error)")
            } else {
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                    print("error \(httpResponse.description)")
                    //print("error \(httpResponse.)")
                    if httpResponse.statusCode == 200{
                        if let str = String(data: data!, encoding: String.Encoding.utf8) {
                            print("Valor de retorno: \(str)")
                            valordevuelto = str
                            
                            if let urlContent = data{
                                do{
                                    let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                    
                                    print("iMPRIMIENDO")
                                    let dato = json as! NSArray
                                    tokentemp = dato[0] as! String
                                    print("Valor de vuelto de sms: \(tokentemp)")
                                } catch{
                                    showmessage(message: "Error en JSON token.")
                                }
                            }
                        }
                    } else {
                        
                    }
                }
            }
        }
        loadTask.resume()
    }
}



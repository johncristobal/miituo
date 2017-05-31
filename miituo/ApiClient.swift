//
//  ApiClient.swift
//  devmiituo
//
//  Created by vera_john on 04/04/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit
import Foundation
import CoreData

//let ip = "http://192.168.1.26:1000/api/"

//let ip = "http://192.168.1.109:1003/api/"

//let ip = "http://miituodev.sytes.net:1001/api/"

let ip = "http://miituodev.sytes.net:1003/api/"

//*******************Function to get data with the celphone*********************************************
/*func getJson(telefon:String){
    
    print("getjson: \(telefon)")
    
    let url = URL(string: "\(ip)InfoClientMobil/Celphone/"+telefon)!
    let session = URLSession.shared
    let loadTask = session.dataTask(with: url){(data,response,error) in
        if error != nil {
            //showmessage(message: "Error de conexiòn: \(error)")
        } else {
            if let urlContent = data{
                
                do{
                    let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    guard let temp = json.value(forKey: "Client") else{
                        //error
                        return
                    }
                    
                    tienepolizas = "si"
                    //else{
                    
                    //store do core data
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
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
                    print(cliente)
                    
                    //forach to get all tjhe polizas here :) ***************************************
                    for index in 0...cliente.count-1{
                        
                        let cli = cliente[index] as! NSDictionary
                        
                        //get client y save data
                        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
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
                            try context.save()
                            print("Saved client")
                        } catch {
                            showmessage(message: "Error al guardar datos")
                        }
                        
                        //get data from client....
                        let polizas = json.value(forKey: "Policies") as! NSArray
                        print("numero de polizas retornadas: \(polizas.count)")
                        
                        
                        //for poli in polizas as! NSDictionary{
                        let poli = polizas[index] as! NSDictionary
                        
                        print("poliza: \(poli)")
                        //print("numero de polizas\(poli.count)")
                        
                        //now the turn os for polizas
                        let newPoli = NSEntityDescription.insertNewObject(forEntityName: "Polizas", into: context)
                        
                        print("idcliente\(idcliente)")
                        newPoli.setValue(idcliente, forKey: "idcliente")
                        //managedObject Core Data
                        let insu = poli["InsuranceCarrier"] as! NSDictionary
                        newPoli.setValue(insu["Name"], forKey: "insurance")
                        
                        let stringodo = (poli["LastOdometer"] as! Int).description
                        newPoli.setValue(String(stringodo), forKey: "lastodometer")
                        
                        let noolizasss = (poli["NoPolicy"] as! String).description
                        //get poliza to sms token
                        //polizaparasms = noolizasss
                        newPoli.setValue(noolizasss, forKey: "nopoliza")
                        
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
                            
                            try context.save()
                            
                            print("Saved poliza \(noolizasss)")
                            
                        } catch {
                            showmessage(message: "Error al guardar datos")
                        }
                        
                        //now the turn os for polizas
                        let newCar = NSEntityDescription.insertNewObject(forEntityName: "Vehiculos", into: context)
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
                            try context.save()
                            
                            print("Saved vehicle")
                            
                        } catch {
                            showmessage(message: "Error al guardar datos")
                        }
                        
                        alertaloadingSplash?.dismiss(animated: true, completion: {
                            self.launchpolizas()
                        })
                        //}
                    }
                    
                } catch{
                    showmessage(message: "Error en JSON datos polizas.")
                }
                
                //launch second view with data - show table and polizas
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                //self.present(vc, animated: true, completion: nil)
            }else{
                showmessage(message: "Sin conexión a Internet. Actualice información más tarde.")
            }
        }
    }
    
    loadTask.resume()
}*/

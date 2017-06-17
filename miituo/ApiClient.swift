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

//let ip = "http://192.168.1.31:1000/api/"

//let ip = "http://192.168.1.109:1003/api/"

let ip = "http://miituodev.sytes.net:1001/api/" //DEV

//let ip = "http://miituodev.sytes.net:1003/api/"   //QAS

var idticket = ""

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
func getJson(telefon:String, vistafrom: UIViewController){
    
    print("getjson: \(telefon)")
    
    let url = URL(string: "\(ip)InfoClientMobil/Celphone/"+telefon)!
    let session = URLSession.shared
    let loadTask = session.dataTask(with: url){(data,response,error) in
        if error != nil {
            showmessage(message: "Error de conexión...")
            //After for to save polizas....
            alertaloadingSplash?.dismiss(animated: true, completion: {
                launchpolizas(vista: vistafrom)
            })
            //return
        } else {
            if let urlContent = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    guard let temp = json.value(forKey: "Client") else{
                        //print(temp)
                        print("error")
                        alertaloadingSplash?.dismiss(animated: true, completion: {
                            launchpolizas(vista: vistafrom)
                        })
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
                        
                    //let cli = cliente[0] as! NSDictionary
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
                        
                    //for index in 0...polizas.count-1{
                        let poli = polizas[index] as! NSDictionary
                        
                        print("poliza: \(poli)")
                        //now the turn os for polizas
                        let newPoli = NSEntityDescription.insertNewObject(forEntityName: "Polizas", into: context)
                        
                        //fecha...
                        let dateString = (poli["LimitReportDate"] as! String).description
                        //let dateString = "2014-01-12"
                        //let fullNameArr = dateString.components(separatedBy: "T")
                        let dateFormatter = DateFormatter()
                        let localeStr = "us" // this will succeed
                        dateFormatter.locale = NSLocale(localeIdentifier: localeStr) as Locale!
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
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
                    
                    //After for to save polizas....
                    alertaloadingSplash?.dismiss(animated: true, completion: {
                        launchpolizas(vista: vistafrom)
                    })
                    //}
                    
                } catch {
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
}


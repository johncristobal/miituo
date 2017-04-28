//
//  PolizasViewController.swift
//  miituo
//
//  Created by vera_john on 10/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit
import CoreData

import SideMenu

var valueToPass = ""
var arreglo = [[String:String]]()
var arregloPolizas = [[String:String]]()
var arreglocarro = [[String:String]]()

var tipoodometro = ""

class PolizasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
        
    @IBOutlet var labelnombre: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self)
        menuLeftNavigationController.leftSide = true
        
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)*/
        
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "derechomenu") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        //SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        //SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        arreglo = [[String:String]]()
        arregloPolizas = [[String:String]]()
        arreglocarro = [[String:String]]()
        
        print("Herefisrt")
        //get userdafyltsvale
        //self.getJson(telefon:"userdafutls")
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            //request for  tables
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let requestpoli = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
            let requestcarro = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehiculos")
            //let results = context.fetch(request)
            request.returnsObjectsAsFaults = false
            requestpoli.returnsObjectsAsFaults = false
            requestcarro.returnsObjectsAsFaults = false

            let results = try context.fetch(request)
            let resultpolizas = try context.fetch(requestpoli)
            let resultcarros = try context.fetch(requestcarro)
            
            //get data from users
            var i = 0;
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let username = result.value(forKey: "name") as? String {
                        
                        //print(username)
                        var tempdict = [String:String]()
                        tempdict["name"] = username
                        
                        //Asignamos nombre de ususaro a pantalla
                        labelnombre.text = username
                        //arreglo.setValue(username, forKey: "name")
                        //print(result.value(forKey: "lastname") as? String)
                        tempdict["lastname"] = result.value(forKey: "lastname") as? String
                        tempdict["mothername"] = result.value(forKey: "lastname") as? String
                        tempdict["token"] = result.value(forKey: "token") as? String
                        tempdict["celphone"] = result.value(forKey: "celphone") as? String
                        //let idstring = result.value(forKey: "id") as? String
                        let idint = result.value(forKey: "id") as! Int
                        tempdict["id"] = String(idint)//result.value(forKey: "id") as? String
                        
                        arreglo.append(tempdict)
                        //print(result.value(forKey: "mothername") as? String)
                        //print(result.value(forKey: "id") as? Int)
                        i += 1
                    }
                }
            } else {
                print("No results")
            }
            
            //get data fro polizas
            var y = 0
            if resultpolizas.count > 0 {
                
                for result in resultpolizas as! [NSManagedObject] {
                    
                    if let polizanumber = result.value(forKey: "nopoliza") as? String {
                        //if let odo = result.value(forKey: "odometerpie") as? String {
                        
                        let insur = result.value(forKey: "insurance") as? String
                        let last = result.value(forKey: "lastodometer") as? String
                        let odo = result.value(forKey: "odometerpie") as? String
                        let rate = result.value(forKey: "rate") as? String
                        let vehic = result.value(forKey: "vehiclepie") as? String
                        let repor = result.value(forKey: "reportstate") as? String
                        let idpoli = result.value(forKey: "idpoliza") as? String
                        
                        let idcliente = result.value(forKey: "idcliente") as! Int

                        //print(odo)
                        //print(vehic)
                        
                        var tempdict2 = [String:String]()
                        tempdict2["nopoliza"] = polizanumber
                        tempdict2["insurance"] = insur//result.value(forKey: "insurance") as? String
                        tempdict2["lastodometer"] = last//result.value(forKey: "lastodometer") as? String
                        tempdict2["odometerpie"] = odo//result.value(forKey: "odometerpie") as? String
                        tempdict2["rate"] = rate//result.value(forKey: "rate") as? String
                        tempdict2["vehiclepie"] = vehic//result.value(forKey: "vehiclepie") as? String
                        tempdict2["reportstate"] = repor//result.value(forKey: "vehiclepie") as? String
                        tempdict2["idpoliza"] = idpoli//result.value(forKey: "vehiclepie") as? String
                        tempdict2["idcliente"] = String(idcliente)//result.value(forKey: "vehiclepie") as? String
                        
                        arregloPolizas.append(tempdict2)
                        y += 1
                    }
                    //}
                }
            } else {
                print("No results")
            }
            
            //arreglos carros-----------
            if resultcarros.count > 0 {
                
                for result in resultcarros as! [NSManagedObject] {
                    
                    if let polizasid = result.value(forKey: "idpolizas") as? String {
                        
                        //print(polizasid)
                        var tempdict3 = [String:String]()
                        tempdict3["idpolizas"] = polizasid
                        tempdict3["capacidad"] = result.value(forKey: "capacidad") as? String
                        tempdict3["color"] = result.value(forKey: "color") as? String
                        tempdict3["brand"] = result.value(forKey: "brand") as? String
                        tempdict3["descripcion"] = result.value(forKey: "descripcion") as? String
                        tempdict3["idcarro"] = result.value(forKey: "idcarro") as? String
                        tempdict3["model"] = result.value(forKey: "model") as? String
                        tempdict3["plates"] = result.value(forKey: "plates") as? String
                        tempdict3["subtype"] = result.value(forKey: "subtype") as? String
                        tempdict3["type"] = result.value(forKey: "type") as? String
                        
                        arreglocarro.append(tempdict3)
                        y += 1
                    }
                }
            } else {
                print("No results")
            }
            
        } catch {
            print("Couldn't fetch results")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }*/
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Return the number of rows in our table
        print("Tmaanio:\(arregloPolizas.count)")
        return arregloPolizas.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //tableView.rowHeight = 75

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        //Define el contenido de la celda
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PolizasTableViewCell
        print("Valor fila: \(indexPath.row)")
        //cell.label.text = String(indexPath.row+1)
        cell.label.text = "Polizas: \(arregloPolizas[indexPath.row]["nopoliza"]! as String)"

        cell.imageicon.backgroundColor = UIColor.red
        //cell.imageicon.layer.backgroundColor = UIColor.init(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: 1.0)
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        
        //whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        return cell
    }

    /*
     When clic in row -> open detalle poliza / fotos 
     It's upon the status fotos
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! PolizasTableViewCell
        
        //valueToPass = currentCell.label.text!
        valueToPass = String(describing:indexPath.row)
        print("Value to pass: \(valueToPass)")

        //Get the parameters of odometerpie and vehiclepie to show the specific viwcontroller
        let reportstate = (arregloPolizas[indexPath.row]["reportstate"]! as String)
        let odometerpie = (arregloPolizas[indexPath.row]["odometerpie"]! as String)
        let vehiclepie = (arregloPolizas[indexPath.row]["vehiclepie"]! as String)
        
        print("Report: \(reportstate)")
        print("Odometerpie: \(odometerpie)")
        print("vehiclepie: \(vehiclepie)")
        
        
        //check the options to show the specific viewcontroller
        if vehiclepie == "false" && odometerpie == "false" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoscar") as! PhotosCarViewController
            //vc.cadenas = valueToPass
            self.present(vc, animated: true, completion: nil)
        }else if vehiclepie == "true" && odometerpie == "false" {
            tipoodometro = "first"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
            //vc.cadenas = valueToPass
            self.present(vc, animated: true, completion: nil)
            //first validte repotstate
        }else if reportstate == "13" {
            tipoodometro = "mensual"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
            //vc.cadenas = valueToPass
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarview") //as! DetallePolizaViewController
            //vc.cadenas = valueToPass
            self.present(vc!, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: "seguewithid", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destinationViewController = segue.destination as! PhotosCarViewController
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    
    func getJson(telefon:String){
        
        let url = URL(string: "http://192.168.1.109:1000/api/InfoClientMobil/Celphone/5534959778")!
        
        let session = URLSession.shared;
        
        let loadTask = session.dataTask(with: url){(data,response,error) in
            if error != nil{
                print(error!)
            } else{
                if let urlContent = data{
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        //store do core data
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                        let requestpolizas = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
                        let requestcarritos = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehiculos")
                        
                        //Delete items from CoreData and get again!!!
                        let fetch = NSBatchDeleteRequest(fetchRequest: request)
                        let result = try context.execute(fetch)
                        let fetchpol = NSBatchDeleteRequest(fetchRequest: requestpolizas)
                        let resultpol = try context.execute(fetchpol)
                        let fetchpolcar = NSBatchDeleteRequest(fetchRequest: requestcarritos)
                        let resultpolcar = try context.execute(fetchpolcar)
                        print(result)
                        print(resultpol)
                        print(resultpolcar)
                        
                        //get client y save data
                        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                        //get data from client....
                        let cliente = json.value(forKey: "Client") as! NSArray
                        print(cliente)
                        let cli = cliente[0] as! NSDictionary
                        print(cli)
                        print(cli.count)
                        
                        let idcliente = cli.value(forKey: "Id")
                        newUser.setValue(idcliente, forKey: "id")
                        //managedObject Core Data
                        let lastnma = String(describing: cli["LastName"])
                        newUser.setValue(lastnma, forKey: "lastname")
                        let motherna = String(describing: (cli["MotherName"]))
                        newUser.setValue(motherna, forKey: "mothername")
                        let nameee = String(describing: (cli["Name"]))
                        newUser.setValue(nameee, forKey: "name")
                        let tokene = String(describing: (cli["Token"]))
                        newUser.setValue(tokene, forKey: "token")
                        let celppp = String(describing: (cli["Celphone"]))
                        newUser.setValue(celppp, forKey: "celphone")
                        
                        var tempdict = [String:String]()
                        tempdict["name"] = nameee
                        //arreglo.setValue(username, forKey: "name")
                        //print(result.value(forKey: "lastname") as? String)
                        tempdict["lastname"] = lastnma
                        tempdict["mothername"] = motherna
                        tempdict["token"] = tokene
                        tempdict["celphone"] = celppp
                        tempdict["id"] = String(describing:idcliente)
                        
                        arreglo.append(tempdict)
                        
                        do {
                            
                            try context.save()
                            
                            print("Saved")
                            
                        } catch {
                            
                            print("There was an error")
                            
                        }
                        
                        //now the turn os for polizas
                        let newPoli = NSEntityDescription.insertNewObject(forEntityName: "Polizas", into: context)
                        //get data from client....
                        let polizas = json.value(forKey: "Policies") as! NSArray
                        print(polizas)
                        let poli = polizas[0] as! NSDictionary
                        print(poli)
                        print(poli.count)
                        
                        newPoli.setValue(idcliente, forKey: "idcliente")
                        //managedObject Core Data
                        let insu = poli["InsuranceCarrier"] as! NSDictionary
                        newPoli.setValue(insu["Name"], forKey: "insurance")
                        let stringodo = String(describing: poli["LastOdometer"])
                        newPoli.setValue(stringodo, forKey: "lastodometer")
                        newPoli.setValue(poli["NoPolicy"], forKey: "nopoliza")
                        let plizasid = poli["NoPolicy"]
                        let odometerbool = (poli["HasOdometerPicture"] as! Bool).description
                        //let stringodometer:String = String(odometerbool.description)
                        newPoli.setValue(odometerbool, forKey: "odometerpie")
                        let vehiclepool = (poli["HasVehiclePictures"] as! Bool).description
                        newPoli.setValue(vehiclepool, forKey: "vehiclepie")
                        let rattt = String(describing: (poli["Rate"]))
                        newPoli.setValue(rattt, forKey: "rate")
                        
                        var tempdict2 = [String:String]()
                        tempdict2["nopoliza"] = String(describing:poli["NoPolicy"])
                        tempdict2["insurance"] = String(describing:insu["Name"])//result.value(forKey: "insurance") as? String
                        tempdict2["lastodometer"] = stringodo//result.value(forKey: "lastodometer") as? String
                        tempdict2["odometerpie"] = (poli["HasOdometerPicture"] as! Bool).description
                        tempdict2["rate"] = rattt//result.value(forKey: "rate") as? String
                        tempdict2["vehiclepie"] = (poli["HasVehiclePictures"] as! Bool).description
                        
                        arregloPolizas.append(tempdict2)
                        
                        //with this let we cna get dat from the vehicle
                        let vehiculo = poli["Vehicle"] as! NSDictionary
                        do {
                            
                            try context.save()
                            
                            print("Saved")
                            
                        } catch {
                            print("There was an error")
                        }
                        
                        //now the turn os for polizas
                        let newCar = NSEntityDescription.insertNewObject(forEntityName: "Vehiculos", into: context)
                        //get data from client....
                        //let polizas = json.value(forKey: "Policies") as! NSArray
                        print(vehiculo)
                        let vei = vehiculo//[0] as! NSDictionary
                        print(vei)
                        print(vei.count)
                        
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
                        let modelito = String(describing:modell["Model"])
                        newCar.setValue(modelito, forKey: "model")
                        newCar.setValue(vei["Plates"], forKey: "plates")
                        let subtyoe = vei["Subtype"] as! NSDictionary
                        newCar.setValue(subtyoe["Description"], forKey: "subtype")
                        let tyype = vei["Type"] as! NSDictionary
                        newCar.setValue(tyype["Description"], forKey: "type")
                        let idc = String(describing:vei["Id"])
                        newCar.setValue(idc, forKey: "idcarro")
                        
                        //print(polizasid)
                        var tempdict3 = [String:String]()
                        tempdict3["idpolizas"] = plizasid as! String?
                        tempdict3["capacidad"] = String(describing:capac)//result.value(forKey: "capacidad") as? String
                        tempdict3["color"] = String(describing:vei["Color"])//result.value(forKey: "color") as? String
                        tempdict3["brand"] = String(describing:brand["Description"])//result.value(forKey: "brand") as? String
                        tempdict3["descripcion"] = String(describing:descrii["Description"])//result.value(forKey: "descripcion") as? String
                        tempdict3["idcarro"] = idc//result.value(forKey: "idcarro") as? String
                        tempdict3["model"] = modelito//result.value(forKey: "model") as? String
                        tempdict3["plates"] = String(describing:vei["Plates"])//result.value(forKey: "plates") as? String
                        tempdict3["subtype"] = String(describing:subtyoe)//result.value(forKey: "subtype") as? String
                        tempdict3["type"] = String(describing:tyype)//result.value(forKey: "type") as? String
                        
                        arreglocarro.append(tempdict3)
                        //with this let we cna get dat from the vehicle
                        //let vehiculo = poli["Vehicle"] as! NSArray
                        do {
                            
                            try context.save()
                            
                            print("Saved")
                            
                        } catch {
                            
                            print("There was an error")
                            
                        }
                        
                        
                    } catch{
                        print("Json process fail")
                    }
                }
            }
        }
        
        loadTask.resume()
        
        //tableview.reloadData()
    }
}

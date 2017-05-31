//
//  SplashViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 02/05/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import MediaPlayer
import CoreData

var saltartoken = ""
var alertaloadingSplash:UIAlertController? = nil

class SplashViewController: UIViewController {
    
    @IBOutlet var imagengif: UIView!
    
    //@IBOutlet var imagengif: UIImageView!

    @IBOutlet var leftconst: NSLayoutConstraint!
    @IBOutlet var topconst: NSLayoutConstraint!
    
    var player: AVPlayer?
    let videoURL: NSURL = Bundle.main.url(forResource: "comp31", withExtension: "mp4")! as NSURL

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

        //let jeremyGif = UIImage.gif(name: "miituosplash")
        //jeremyGif?.duration = 3
        
        //imagengif.loadGif(name: "miituosplash")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        print("Ancho: \(screenWidth)")
        print("Alto: \(screenHeight)")
        
        if screenHeight > 660 {
            topconst.constant = 40
            leftconst.constant = 22
        }
        if screenHeight > 730 {
            topconst.constant = 50
            leftconst.constant = 40
        }
        
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //playerLayer.zPosition = -1
        
        playerLayer.frame = imagengif.frame
        
        self.imagengif.layer.addSublayer(playerLayer)
        
        player?.play()
    }

    func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        print(userInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchlerta(cel: String){
        alertaloadingSplash = UIAlertController(title: "Información", message: "Actualizando datos...", preferredStyle: .alert)
        
        alertaloadingSplash?.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alertaloadingSplash?.view.addSubview(loadingIndicator)
        present(alertaloadingSplash!, animated: true, completion: nil)
        
        //DispatchQueue.global(qos: .userInitiated).async {
        //update token
        self.sendToken(telefono: cel as! String)
        //get data from WS
        self.getJson(telefon: cel as! String);
        //get data from WS
        //self.getSms(telefon: cel as! String);
        
        //DispatchQueue.main.async {
        //self.imageView.image = image
        //launch second view with data - show table and polizas
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        //self.present(vc, animated: true, completion: nil)
        
        /*
         Now we dont have to launch the polizas view
         before, we have to launch sms view to token validation
         */
        
        //close loading view
        //alertaloading?.dismiss(animated: true, completion: {
        
        //self.launchpolizas()
        /*if tienepolizas != ""{
         self.launchpolizas()
         }else{
         print("No hay polzias")
         
         showmessage(message: "No hay polizas vinculadas. Intente con otro número")
         }*/
        /*if saltartoken == "1"{
         self.launchpolizas()
         }else {
         self.launchtoken()
         }*/
        //})
        //}
        //}
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            // Put your code which should be executed with a delay here
            if (UserDefaults.standard.value(forKey: "tutoya") != nil){

                saltartoken = "1"
                if let cel = UserDefaults.standard.value(forKey: "celular") {
                    print(cel)
                    
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        print("Not connected")
                        self.launchpolizas()
                    case .online(.wwan):
                        self.launchlerta(cel: cel as! String)
                    case .online(.wiFi):
                        self.launchlerta(cel: cel as! String)
                        print("Connected via WiFi")
                    }
                    
                    /*alertaloadingSplash = UIAlertController(title: "Información", message: "Actualizando pólizas...", preferredStyle: .alert)
                    
                    alertaloadingSplash?.view.tintColor = UIColor.black
                    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                    loadingIndicator.startAnimating();
                    
                    alertaloadingSplash?.view.addSubview(loadingIndicator)
                    self.present(alertaloadingSplash!, animated: true, completion: nil)
                    
                    //DispatchQueue.global(qos: .userInitiated).async {
                    //update token
                    self.sendToken(telefono: cel as! String)
                    //get data from WS
                    self.getJson(telefon: cel as! String)*/
                    //get data from WS
                    //self.getSms(telefon: cel as! String);
                    
                    //DispatchQueue.main.async {
                    //self.imageView.image = image
                    //launch second view with data - show table and polizas
                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                    //self.present(vc, animated: true, completion: nil)
                    
                    /*
                     Now we dont have to launch the polizas view
                     before, we have to launch sms view to token validation
                     */
                    
                    //close loading view
                    //alertaloading?.dismiss(animated: true, completion: {
                    
                    //self.launchpolizas()
                    /*if tienepolizas != ""{
                     self.launchpolizas()
                     }else{
                     print("No hay polzias")
                     
                     showmessage(message: "No hay polizas vinculadas. Intente con otro número")
                     }*/
                    /*if saltartoken == "1"{
                     self.launchpolizas()
                     }else {
                     self.launchtoken()
                     }*/
                    //})
                    //}
                    //}
                }else {                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myAlert = storyboard.instantiateViewController(withIdentifier: "fourSB") as! ViewController
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    
                    self.present(myAlert, animated: true, completion: nil)
                }

            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myAlert = storyboard.instantiateViewController(withIdentifier: "onboardingview") as! TutorialViewController
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                self.present(myAlert, animated: true, completion: nil)
            }
        })
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "onboardingview") as! TutorialViewController
        //self.present(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
/*********************** launch polizas***************************************************/
    func launchpolizas(){
        //launch second view with data - show table and polizas
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(vc, animated: true, completion: nil)        
    }
    
/*********************** launch token***************************************************/
    func launchtoken(){
        //launch second view with data - show table and polizas
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "smsview") as! TokenSmsViewController
        self.present(vc, animated: true, completion: nil)
        
    }
//***************************Function to send token to ws*********************************************
    func sendToken(telefono: String){
        let todosEndpoint: String = "\(ip)ClientUser/"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //let newTodo: [String: Any] = ["Celphone":"5534959778","Id":"0","Token":"aaaaaaaaaaa"]
        let newTodo: [String: Any] = ["Celphone": telefono, "Token": token, "Id":"0"]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
            print("Token: \(jsonString)")
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
                
                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
    
//*******************Function to get data with the celphone*********************************************
    func getJson(telefon:String){
        
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
                        }
                        
                        //Afetr for to save polizas....
                        alertaloadingSplash?.dismiss(animated: true, completion: {
                            self.launchpolizas()
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
}

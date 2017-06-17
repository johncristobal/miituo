//
//  ViewController.swift
//  devmiituo
//
//  Created by vera_john on 21/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit
import CoreData
import Photos
import SystemConfiguration
import UserNotifications

var alertaloading:UIAlertController? = nil
var polizaparasms:String? = ""
var tokentemp:String? = ""

var tienepolizas = ""

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //let priority = DispatchQueue.GlobalQueuePriority.default
    
    @IBOutlet var label: UILabel!
    @IBOutlet var telefono: UITextField!

    @IBOutlet var fototemp: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let application: UIApplication = UIApplication.shared
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            //UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            //FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        /*let largeNumber = 31908551587
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let finalnumber = numberFormatter.string(from: NSNumber(value: largeNumber))
        telefono.text = finalnumber*/
        
        /*let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        fototemp.isUserInteractionEnabled = true
        fototemp.addGestureRecognizer(tapGestureRecognizer)

        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("fotoA.png")
        if fileManager.fileExists(atPath: filename.path){
            let image = UIImage(contentsOfFile: filename.path)
            fototemp.layer.cornerRadius = 20.0
            fototemp.transform = fototemp.transform.rotated(by: CGFloat(Double.pi/2))
            fototemp.layer.masksToBounds = true
            fototemp.image = image
        }else{
            print("No existe foto")
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }

    func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        print(userInfo)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        //Code to launch camera and take picture
        /*if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true)
        } else {
            print("can't find camera")
        }*/
        
        //Code to launch picture and watch picture
        /*let imageView = tapGestureRecognizer.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .beginFromCurrentState, animations: {
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            //newImageView.transform = newImageView.transform.rotated(by: CGFloat(Double.pi/2))
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        },completion: {_ in})*/
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        /*fototemp.layer.cornerRadius = 20.0
        fototemp.layer.masksToBounds = true
        fototemp.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self.fototemp.image!)
        }, completionHandler: { success, error in
            if success {
                // Saved successfully!
                if let data = UIImagePNGRepresentation(self.fototemp.image!) {
                    let filename = self.getDocumentsDirectory().appendingPathComponent("fotoA.png")
                    try? data.write(to: filename)
                    
                    print("imagen guardada")
                }
            }
            else if let error = error {
                // Save photo failed with error
            }
            else {
                // Save photo failed with no error
            }
        })*/
    }
    
    func getDocumentsDirectory() -> URL {
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
         if i have acelhpone on the memory...just call getJson
         unless set the view and get the number...
         */

        // Move to a background thread to do some long running work
        
        if let cel = UserDefaults.standard.value(forKey: "celular") {
            print(cel)
            
            //Validate connection...wifi/datos...if not connection...launch polizas directly....
            //....
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                print("Not connected")
                self.launchpolizas()
            case .online(.wwan):
                launchlerta(cel: cel as! String)
            case .online(.wiFi):
                launchlerta(cel: cel as! String)
                print("Connected via WiFi")
            }
        } else {
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                print("Not connected")
                self.launchpolizas()
            case .online(.wwan):
                print("Connected via WiFi")
            case .online(.wiFi):
                print("Connected via WiFi")
            }
        }
    }
    
    func launchlerta(cel: String){
        alertaloading = UIAlertController(title: "Información", message: "Actualizando datos...", preferredStyle: .alert)
        
        alertaloading?.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alertaloading?.view.addSubview(loadingIndicator)
        present(alertaloading!, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
        //update token
        self.sendToken(telefono: cel as! String)
        //get data from WS
        //self.getJson(telefon: cel as! String);
        getJson(telefon: cel as! String, vistafrom: self);

        //get data from WS
        //self.getSms(telefon: cel as! String);
        
        DispatchQueue.main.async {
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
        }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendPhone(_ sender: Any) {
        let tel = telefono.text! as String
        
        if tel != "" {

            alertaloading = UIAlertController(title: nil, message: "Sincronizando...", preferredStyle: .alert)
            
             alertaloading?.view.tintColor = UIColor.black
             //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
             let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
             loadingIndicator.hidesWhenStopped = true
             loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
             loadingIndicator.startAnimating();
             
             alertaloading?.view.addSubview(loadingIndicator)
             present(alertaloading!, animated: true, completion: nil)

            // Move to a background thread to do some long running work
            DispatchQueue.global(qos: .userInitiated).async {
            //let image = self.loadOrGenerateAnImage()
            // Bounce back to the main thread to update the UI
            print(tel)
            
            //Save data to UserDefautls
            UserDefaults.standard.setValue("1", forKey: "tutoya")
            UserDefaults.standard.setValue(tel, forKey: "celular")
            //update token
            self.sendToken(telefono: tel)
            //get data from WS
            //self.getJson(telefon: tel);
            getJson(telefon: tel as! String, vistafrom: self);

            //get data from WS
            self.getSms(telefon: tel);

            DispatchQueue.main.async {
                //close loading view
                //alertaloading?.dismiss(animated: false, completion: nil)
                alertaloading?.dismiss(animated: true, completion: {
                    
                    self.launchtoken()
                    /*if tienepolizas != ""{
                        self.launchtoken()
                    }else{
                        print("No hay polzias")
                        showmessage(message: "No hay polizas vinculadas. Intente con otro número")
                    }*/
                })
            }
        }
        }else{
            
            showmessage(message: "Introduzca número celular");
        }

        //call class to get json
        //let task = Task()
    }    

/*********************** launch polizas***************************************************/
    func launchpolizas(){
        //launch second view with data - show table and polizas
        /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(vc, animated: true, completion: nil)*/

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        //launch second view with data - show table and polizas
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(myAlert, animated: true, completion: nil)
    }

/*********************** launch token***************************************************/
    func launchtoken(){
        //launch second view with data - show table and polizas
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "smsview") as! TokenSmsViewController
        self.present(vc, animated: true, completion: nil)
        
    }

    //Get out of the textfield*********************************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Termina edicion
        self.view.endEditing(true)
    }
    
    //Cuando das clic en return dek teclado*********************************************
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
                            print("fecha limite: \(dateStringfin)")
                            newPoli.setValue(s, forKey: "limitefecha")

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
                            
                            alertaloading?.dismiss(animated: true, completion: {
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
    
//*******************Function to get data with the celphone*********************************************
    func getSms(telefon:String){
        
        let flag = true
        while flag{
            if polizaparasms != ""{
                break;
            }
        }
        
        let url = URL(string: "\(ip)TemporalToken/GetTemporalTokenPhone/"+telefon+"/"+polizaparasms!+"/AppToken")!
        let session = URLSession.shared;
        let loadTask = session.dataTask(with: url){(data,response,error) in
            if error != nil{
                showmessage(message: "Error de conexiòn \(error)")
            } else {
                if let urlContent = data{
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print("iMPRIMIENDO")
                        let dato = json as! NSArray
                        tokentemp = dato[0] as! String
                        print("Valor de vuelto de sms: \(tokentemp)")
                        //get data from client....
                        //let cliente = json.value(forKey: "Client") as! NSArray
                        //print(cliente)
                        
                    } catch{
                        showmessage(message: "Error en JSON token.")
                    }
                    
                    //launch second view with data - show table and polizas
                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                    //self.present(vc, animated: true, completion: nil)
                }
            }
        }
        loadTask.resume()
    }
}


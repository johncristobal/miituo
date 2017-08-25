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
import FirebaseInstanceID

var saltartoken = ""
var alertaloading:UIAlertController? = nil

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
        /*NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()*/

        //let jeremyGif = UIImage.gif(name: "miituosplash")
        //jeremyGif?.duration = 3
        
        //imagengif.loadGif(name: "miituosplash")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        print("Ancho: \(screenWidth)")
        print("Alto: \(screenHeight)")
        
        //Mas a la derecha y un poco mas abajo
        
        if screenHeight > 560 {
            topconst.constant = 50
            leftconst.constant = 10
        }
        if screenHeight > 660 {
            topconst.constant = 85
            leftconst.constant = 40
        }
        if screenHeight > 730 {
            topconst.constant = 100
            leftconst.constant = 50
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
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        DispatchQueue.global(qos: .userInitiated).sync {
        //update token
        self.sendToken(telefono: cel as! String)
        //get data from WS
        getJson(telefon: cel as! String, vistafrom: self,dedonde:"splash")
        //get data from WS
        //self.getSms(telefon: cel as! String);
        
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
        }
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
                        if let token = UserDefaults.standard.value(forKey: "sesion") {
                            
                            //DispatchQueue.main.async {
                                //close loading view
                                //alertaloading?.dismiss(animated: true, completion: {
                                    self.launchpolizas()
                                //})
                            //}
                        }
                        else
                        {
                            //get data from WS
                            //getSms(telefon: cel as! String);
                            
                            //DispatchQueue.main.async {
                                //close loading view
                                //alertaloading?.dismiss(animated: true, completion: {
                                    //self.launchtoken()
                                //})
                            //}
                        }

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "smsview") as! TokenSmsViewController
        self.present(vc, animated: true, completion: nil)
        
    }
//***************************Function to send token to ws*********************************************
    func sendToken(telefono: String){
        let todosEndpoint: String = "\(ip)ClientUser/"
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            token = refreshedToken
        }
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //let newTodo: [String: Any] = ["Celphone": "5532241245", "Token": token, "Id":"0"]
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
        
        //Start thread to send data
        let session = URLSession.shared
        let task = session.dataTask(with: todosUrlRequest) {
            (responseData, response, error) in
            /*guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
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
                }else{
                    //catch error to log
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
                                                                                  options: []) as? [String: Any] else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                     }
                     print("The todo is: " + receivedTodo.description)
                     
                     } catch  {
                        print("error parsing response from POST on /todos")
                        return
                     }
                }
            }
            
            // parse the result as JSON, since that's what the API provides
            /*do {
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
            }*/
        }
        task.resume()
    }    
}

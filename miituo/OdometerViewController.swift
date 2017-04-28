//
//  OdometerViewController.swift
//  devmiituo
//
//  Created by vera_john on 27/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit

var picker2 = UIImagePickerController()

var valordevuelto = ""
var odometerflag = 0

class OdometerViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet var imageodometer: UIImageView!
    //@IBOutlet var odometrouno: UITextField!
    //@IBOutlet var odometrodos: UITextField!
    
    var odometrofinal = ""
    
    var datareturned = [String:String]()

    var rowsel = 0;
    
    let alertaloading = UIAlertController(title: nil, message: "Subiendo imagen...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageodometer.isUserInteractionEnabled = true
        imageodometer.addGestureRecognizer(tapGestureRecognizer)

        rowsel = Int(valueToPass)!
        print("roswel: \(rowsel)")
        let poliza = arregloPolizas[rowsel]["idpoliza"]! as String
        print("idpoliza----------------\(poliza)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //let picker = UIImagePickerController()
            picker2.delegate = self
            picker2.sourceType = UIImagePickerControllerSourceType.camera
            picker2.allowsEditing = true
            self.present(picker2, animated: true)
        } else {
            print("can't find camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker2.dismiss(animated: true, completion: nil)
        imageodometer.image = info[UIImagePickerControllerOriginalImage] as? UIImage

        odometerflag = 1
    }
    
    @IBAction func listoOdometer(_ sender: Any) {
        if odometerflag == 1{
            let imagennn = imageodometer.image
            let idpic = "5"
            sendimagenes(imagenn: imagennn!,idpic: idpic)
            
        }else {
            showmessage(message: "Capturar foto de tu odometro para continuar")
        }
    }
    //@IBOutlet var listoOdometer: UIBarButtonItem!
    /*@IBAction func sendOdometer(_ sender: Any) {
        if odometerflag == 1{
            let imagennn = imageodometer.image
            let idpic = "5"
            sendimagenes(imagenn: imagennn!,idpic: idpic)

        }else {
            showmessage(message: "Capturar foto de tu odometro para continuar")
        }
    }*/
    
    func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = 300
        var maxWidth : CGFloat = 400.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        //var rect = CGRect(0.0, 0.0, actualWidth, actualHeight);
        var rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: actualWidth, height: actualHeight));
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        var img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImagePNGRepresentation(img!);
        UIGraphicsEndImageContext();
        
        return imageData!;
    }

    func sendimagenes(imagenn:UIImage, idpic:String){
        
        openloading(mensaje: "")
        
        let comrimidad = compressImage(image: imagenn)
        
        // to base64 => yhis is going to be in the thread to send photos
        let strBase64 = comrimidad.base64EncodedString(options: [])
        
        /// ----------- send iamge ------------ ///
        let todosEndpoint: String = "\(ip)ImageProcessing/"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let newTodo: [String: Any] = ["Type": idpic, "Data": strBase64, "PolicyId":arregloPolizas[rowsel]["idpoliza"]! as String ,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"]! as String]
        //let newTodo: [String: Any] = ["Type": "1", "PolicyId":"59" ,"PolicyFolio":"884489275","Odometer":"1233333"]
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
                valordevuelto = receivedTodo["Message"] as! String
                /*guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")*/
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
        
        //--------------------------------------validamos informacion.................................
        //if valordevuelto == "true"{
        alertaloading.dismiss(animated: true, completion: {
            let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
        
            //openview
            self.present(odometerview, animated: true, completion: nil)
        })
        
        /*
**************
         Cambio => no hay mas OCR,
         ahora se colocan dos textfields to get info
         
         if carros => solo manda info y ya
         else => manda info y obtienes datos de cargos
**************
         */
        
        /*if ventana == "carros" {
            //launch view to confirm odometer first time
            /*
            let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
        
             //openview
             self.present(odometerview, animated: true, completion: nil)
            */
            
            confirmOdometer()
            
        } else {
            
            let odometroaenviar = ""//odometrouno.text! as String
            
            if odometroaenviar == ""{
                showmessage(message: "Colocar cantidad a enviar")
            }else{
                
                var refreshAlert = UIAlertController(title: "Confirmar odometro", message: "¿Desea confirmar el odometro?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.sendReportOdometer()
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
        }*/
        
    }

    //Launch alerta
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
    
/*
     *********************************confrma odometro first time********************
*/
    func confirmOdometer() {
        let cadena = ""//odometrouno.text
        
        // to base64 => yhis is going to be in the thread to send photos
        //let imageData:NSData = UIImagePNGRepresentation(comrimidad)! as NSData
        
        //let strBase64 = comrimidad.base64EncodedString(options: [])
        
        //print(strBase64)
        /// ----------- send iamge ------------ ///
        let todosEndpoint: String = "\(ip)ImageProcessing/ConfirmOdometer"

        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let newTodo: [String: Any] = ["Type": "5", "Odometer": cadena, "PolicyId":arregloPolizas[rowsel]["idpoliza"] as! String,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"] as! String]
        //let newTodo: [String: Any] = ["Type": "1", "PolicyId":"59" ,"PolicyFolio":"884489275","Odometer":"1233333"]
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
                valordevuelto = receivedTodo["Message"] as! String
                /*guard let todoID = receivedTodo["id"] as? Int else {
                 print("Could not get todoID as int from JSON")
                 return
                 }
                 print("The ID is: \(todoID)")*/
            } catch  {
                print("error parsing response from POST on /todos")
                //return
            }
        }
        task.resume()
        
        //Before this we have to udate the reportstate
        //....
        
        //launch view to confirm odometer
        let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        
        //openview
        self.present(odometerview, animated: true, completion: nil)
    }
    
/*
     *********************************confrma odometro mes a mes********************
*/
    func sendReportOdometer(){
        let cadena = ""//odometrouno.text
        
        /// ----------- send iamge ------------ ///
        let todosEndpoint: String = "\(ip)ReportOdometer/"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let vala = arregloPolizas[rowsel]["idpoliza"] as! String
        let valb = arregloPolizas[rowsel]["nopoliza"] as! String
        let valc = arregloPolizas[rowsel]["idcliente"] as! String
        
        print("vala:\(vala)")
        print("valb:\(valb)")
        print("valc:\(valc)")
        
        let datainter: [String: Any] = ["PolicyId":arregloPolizas[rowsel]["idpoliza"] as! String,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"] as! String,"Odometer":cadena,"ClientId":arregloPolizas[rowsel]["idcliente"] as! String]
        let newTodo: [String: Any] = ["Type": "1","ImageItem":datainter]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let semaphore = DispatchSemaphore(value: 0);
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
                    showmessage(message: meessage as! String)
                    odometro = "no"
                } else {
                    flag = true
                    
                    let totalmes = receivedTodo["Amount"]
                    self.datareturned["odohoy"] = String(describing:totalmes)
                    
                    let tarifafijames = receivedTodo["Parameters"] as! NSArray
                    let tarifafija = (tarifafijames[0] as AnyObject).value(forKey: "Amount") as! Int
                    let promocion = (tarifafijames[1] as AnyObject).value(forKey: "Amount") as! Int
                    
                    print("tarifafjia: \(tarifafija)")
                    print("promo: \(promocion)")
                    
                    //update values to send to the cystom alert
                    //odometro = String(describing:promocion)
                    odometro = cadena
                    
                    semaphore.signal();
                    
                    DispatchQueue.global(qos: .userInitiated).async { // 1
                        //let overlayImage = self.faceOverlayImageFromImage(self.image)
                        DispatchQueue.main.async { // 2
                            
                            if odometro != "no" {
                                //show alert with data
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
                                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            } catch  {
                print("error parsing response from POST on /todos")
                //return 125445
            }
        }
        
        task.resume()
        //semaphore.wait()
        let resut = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: 2000))
        print("Semaforo:\(resut)")
        
        print("Out of here")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //Get out of the textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Termina edicion
        self.view.endEditing(true)
    }
    
    //Cuando das clic en return dek teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }    
}

//
//  OdometerViewController.swift
//  devmiituo
//
//  Created by vera_john on 27/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

var picker2 = UIImagePickerController()

var valordevuelto = ""
var odometerflag = 0

var speed = ""

class OdometerViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet var imageodometer: UIImageView!
    @IBOutlet var openCamera: UIButton!
    
    //@IBOutlet var odometrouno: UITextField!
    //@IBOutlet var odometrodos: UITextField!
    
    var odometrofinal = ""
    
    var datareturned = [String:String]()

    var rowsel = 0;
    
    let alertaloading = UIAlertController(title: "Registro de odómetro", message: "Subiendo imagen...", preferredStyle: .alert)

    //let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //manager.delegate = self
        //manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.requestWhenInUseAuthorization()
        //manager.startUpdatingLocation()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageodometer.isUserInteractionEnabled = true
        imageodometer.addGestureRecognizer(tapGestureRecognizer)

        rowsel = Int(valueToPass)!
        print("roswel: \(rowsel)")
        let poliza = arregloPolizas[rowsel]["idpoliza"]! as String
        print("idpoliza----------------\(poliza)")

        odometerflag = 0

        // Do any additional setup after loading the view.
        //let image = UIImage(named: "miituo.png")
        //alertaloading.setValue(image, forKey: "image")
    }

    
    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        openCamera.setTitle("Continuar", for: .normal)
    }

//************************ launcho camera********************************************//
    @IBAction func listoOdometer(_ sender: Any) {
        if odometerflag == 1 {
            let imagennn = imageodometer.image
            
            var idpic = "5"
            if tipoodometro == "cancela"{
                idpic = "6"
            }else{
                idpic = "5"
            }
            //sendimagenes(imagenn: imagennn!,idpic: idpic)
            sendimagenesdataarraya(imagenn: imagennn!,idpic: idpic)
        }else {
            showmessage(message: "Capturar foto de tu odometro para continuar")
        }
    }

//Generate boundary
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

//************************ send image to WS********************************************//
    func sendimagenesdataarraya(imagenn:UIImage, idpic:String) {
        
        openloading(mensaje: "")

        //compress image
        let comrimidad = compressImage(image: imagenn)
        let tok = arreglo[self.rowsel]["token"]!
        
        //prueba alamorife
        let boundary = generateBoundaryString()
        
        let parameters = ["Type": idpic,"PolicyId":arregloPolizas[rowsel]["idpoliza"] ,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"]]
        //let head = ["Authorization": tok,"Content-Type":"multipart/form-data; boundary=\(boundary)"]
        let head = ["Authorization": tok,"Content-Type":"application/json"]
        
        //Alamofire to upload image
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(comrimidad, withName: "image",fileName: "file\(idpic).jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },to:"\(ip)ImageSendProcess/Array/",headers:head)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    print(response.result.description)
                    
                    let entero = response.result.description
                    
                    switch entero{
                    case "SUCCESS":
                        self.launch_odometer()
                        /*case "2":
                         if idpic == "3"{
                         self.launch_odometer()
                         }
                         case "3":
                         if idpic == "3"{
                         self.launch_odometer()
                         }
                         case "4":
                         if idpic == "3"{
                         self.launch_odometer()
                         }*/
                    default:
                        //Error al subir imagen.
                        self.launch_alert()
                    }
                }
                
            case .failure(let encodingError):
                print("error \(encodingError)")
                self.launch_alert()
            }
        }
    }

//************************ compress image********************************************//
    func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        //var maxHeight : CGFloat = 450.0
        //var maxWidth : CGFloat = 600.0
        var maxHeight : CGFloat = image.size.height/4//300
        var maxWidth : CGFloat = image.size.width/4//400.0

        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.8
        
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
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: actualWidth, height: actualHeight));
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        //let imageData = UIImagePNGRepresentation(img!);
        let imageData = UIImageJPEGRepresentation(img!,0.9);
        UIGraphicsEndImageContext();
        
        return imageData!;
    }

//************************ DEPRECATED********************************************//
    func sendimagenes(imagenn:UIImage, idpic:String){
        
        openloading(mensaje: "")
        
        let comrimidad = compressImage(image: imagenn)
        let tok = arreglo[self.rowsel]["token"]!

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
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")
        
        let newTodo: [String: Any] = ["Type": idpic, "Data": strBase64, "PolicyId":arregloPolizas[rowsel]["idpoliza"]! as String ,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"]! as String]

        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            print(jsonString)
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
                        
                        DispatchQueue.main.async {                         
                             self.alertaloading.dismiss(animated: true, completion: {
                             let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
                             
                             odometerview.modalPresentationStyle = UIModalPresentationStyle.pageSheet
                             
                             //openview
                             self.present(odometerview, animated: true, completion: nil)
                             })
                         }

                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                } else {
                    //catch error...
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,
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
                        if valordevuelto != "1000" {
                            DispatchQueue.main.async {

                            self.alertaloading.dismiss(animated: true, completion: {
                                
                                print("Valoe ------------ devuelto ----------")
                                print(valordevuelto)
                                
                                let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.launcpolizas()
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                            })
                            }
                        }else{
                            /*DispatchQueue.main.async {

                            self.alertaloading.dismiss(animated: true, completion: {
                                let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
                                
                                odometerview.modalPresentationStyle = UIModalPresentationStyle.pageSheet
                                
                                //openview
                                self.present(odometerview, animated: true, completion: nil)
                            })
                            }*/
                        }
                        
                    } catch {
                        print("error parsing response from POST on /todos")
                        //return
                    }

                }
            }
        }
        task.resume()
    }

//************************ launch amcraimage********************************************//
    @IBAction func cameraLaunch(_ sender: Any) {
        
        if odometerflag == 1{
            let imagennn = imageodometer.image
            var idpic = "5"
            if tipoodometro == "cancela"{
                idpic = "6"
            }else{
                idpic = "5"
            }

            //sendimagenes(imagenn: imagennn!,idpic: idpic)
            sendimagenesdataarraya(imagenn: imagennn!,idpic: idpic)

        }else {
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
    }

//************************ compress image********************************************//
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
    
//************************ lauch polzas********************************************//
    func launcpolizas(){
        //launch view to confirm odometer
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        //launch second view with data - show table and polizas
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
        self.present(myAlert, animated: true, completion: nil)
    }
    
//************************ launch odometer WS********************************************//
    func launch_alert() {
        DispatchQueue.main.async {
            self.alertaloading.dismiss(animated: true, completion: {
                
                let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.launcpolizas()

                    //self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(refreshAlert, animated: true)
            })
        }
    }
    
//************************ launch odometer WS********************************************//
    func launch_odometer() {
        //Lanzamos siguiente odometro
        DispatchQueue.main.async {
            do{
                //UpdatereportStet from CoreData
                //store do core data
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if #available(iOS 10.0, *) {
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let requestpolizas = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
                    
                    //var fetchRequest = NSFetchRequest(entityName: "LoginData")
                    requestpolizas.predicate = NSPredicate(format: "nopoliza = %@", arregloPolizas[self.rowsel]["nopoliza"] as! String)
                    
                    let test = try context.fetch(requestpolizas)
                    if test.count == 1
                    {
                        let objectUpdate = test[0] as! NSManagedObject
                        
                        objectUpdate.setValue("true", forKey: "odometerpie")
                        
                        do{
                            try context.save()
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                } else {
                    // Fallback on earlier versions
                    showmessage(message: "Actualiza iOS para ver las mejoras del sistema.")
                }
            }catch {
                showmessage(message: "Error al actualizar estatus")
            }
            
            self.alertaloading.dismiss(animated: true, completion: {
                
                let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
                
                odometerview.modalPresentationStyle = UIModalPresentationStyle.pageSheet
                
                //openview
                self.present(odometerview, animated: true, completion: nil)
            })
        }
    }
}


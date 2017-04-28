//
//  PhotosCarViewController.swift
//  devmiituo
//
//  Created by vera_john on 22/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit

var picker = UIImagePickerController()

var base64string:String = ""
var leftflag = 0
var rigthflag = 0
var frontflag = 0
var backflag = 0

class PhotosCarViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var derechopic: UIImageView!
    @IBOutlet var frontpic: UIImageView!
    @IBOutlet var izquierdopic: UIImageView!
    @IBOutlet var backpic: UIImageView!
    
    var imagenselected = 0
    
    var rowsel = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ventana = carros => photos first time
        tipoodometro = "first"

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizerfront = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizerrigth = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizerback = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        //add gesture recogni<ar to get pucter when image clic
        derechopic.isUserInteractionEnabled = true
        derechopic.addGestureRecognizer(tapGestureRecognizer)
        
        frontpic.isUserInteractionEnabled = true
        frontpic.addGestureRecognizer(tapGestureRecognizerfront)

        izquierdopic.isUserInteractionEnabled = true
        izquierdopic.addGestureRecognizer(tapGestureRecognizerrigth)

        backpic.isUserInteractionEnabled = true
        backpic.addGestureRecognizer(tapGestureRecognizerback)
        
        rowsel = Int(valueToPass)!
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        imagenselected = tappedImage.tag
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true)
        } else {
            print("can't find camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if imagenselected == 1 {
            derechopic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            rigthflag = 1
            //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
        } else if imagenselected == 2 {
            frontpic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            frontflag = 1
            //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
        } else if imagenselected == 3 {
            izquierdopic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            leftflag = 1
            //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
        } else if imagenselected == 4 {
            backpic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            backflag = 1
            //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = image.size.height/4//300
        var maxWidth : CGFloat = image.size.width/4//400.0
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

    @IBAction func sendDataBar(_ sender: Any) {
        //showmessage(message: "Enviando información")
        if rigthflag == 1 && leftflag == 1 && frontflag == 1 && backflag == 1{
            //send all picturec...loop to get all the iamges and send them
            
            for index in 0...3 {
                
                if index == 0{
                    let imagennn = derechopic.image
                    let idpic = "2"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
                if index == 1{
                    let imagennn = frontpic.image
                    let idpic = "1"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
                if index == 2{
                    let imagennn = izquierdopic.image
                    let idpic = "4"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
                if index == 3{
                    let imagennn = backpic.image
                    let idpic = "3"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
            }
            
            //At last...open the new viewcontrooler
            //Open view odometer to get picture of odometer
            let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
            //openview
            self.present(odometerview, animated: true, completion: nil)
            
        }else{
            showmessage(message: "Capturar todas las fotografìas solicitadas")
        }
    }
    
    //Evento del boton para mandar iamgnes
    /*@IBAction func sendData(_ sender: Any) {
 
        if rigthflag == 1 && leftflag == 1 && frontflag == 1 && backflag == 1{
            //send all picturec...loop to get all the iamges and send them
            
            for index in 0...3 {
                
                if index == 0{
                    let imagennn = derechopic.image
                    let idpic = "2"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
                if index == 1{
                    let imagennn = frontpic.image
                    let idpic = "1"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
                if index == 2{
                    let imagennn = izquierdopic.image
                    let idpic = "4"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
                if index == 3{
                    let imagennn = backpic.image
                    let idpic = "3"
                    sendimagenes(imagenn: imagennn!,idpic: idpic)
                }
            }
            
            //At last...open the new viewcontrooler
            //Open view odometer to get picture of odometer
            let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
            //openview
            self.present(odometerview, animated: true, completion: nil)

        }else{
            showmessage(message: "Capturar todas las fotografìas solicitadas")
        }
    }*/
    
    func sendimagenes(imagenn:UIImage, idpic:String){
            
        //compress image
        let comrimidad = compressImage(image: imagenn)
        
        // to base64 => yhis is going to be in the thread to send photos
        //let imageData:NSData = UIImagePNGRepresentation(comrimidad)! as NSData
        
        let strBase64 = comrimidad.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
        //let strBase64 = comrimidad.base64EncodedString(options: [.])
        
        //print(strBase64)
        
        /// ----------- send iamge ------------ ///
        //let todosEndpoint: String = "http://192.168.1.109:1000/api/ImageProcessing/ConfirmOdometer"
        let todosEndpoint: String = "\(ip)ImageProcessing/"
        //let todosEndpoint: String = "http://192.168.1.109:1000/api/ClientUser/"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        //todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //let newTodo: [String: Any] = ["Id": "70", "Name": "Edrei", "LastName":"bastar" ,"MotherName":"bastar","Celphone":"5534959778","Token":"aaaaaaaaaaa"]
        //let newTodo: [String: Any] = ["Celphone":"5534959778","Id":"0","Token":"aaaaaaaaaaa"]
        let newTodo: [String: Any] = ["Type": idpic, "Data": strBase64, "PolicyId":arregloPolizas[rowsel]["idpoliza"] ,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"]]
        //let newTodo: [String: Any] = ["Type": "1", "PolicyId":"59" ,"PolicyFolio":"884489275","Odometer":"1233333"]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            let jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
            print(jsonString)
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
}

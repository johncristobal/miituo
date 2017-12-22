//
//  PolizasViewController.swift
//  miituo
//
//  Created by vera_john on 10/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import CoreLocation

import UIKit
import CoreData

import SideMenu
import Photos
import CoreData

import Social

import FacebookShare

var valueToPass = ""
var arreglo = [[String:String]]()
var arregloPolizas = [[String:String]]()
var arreglocarro = [[String:String]]()
var celular = ""

var flagcontrol = "0"

var valornum:Double = 0.0

var nombrecliente = ""

var actualizar = "0"

var volteado = "0"
var message = 0

class PolizasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet var tableview: UITableView!
        
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var labelnombre: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var hola: UILabel!
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var leyendalabel: UILabel!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        /*labelnombre.font = UIFont(name: "herne1.ttf", size: 16.0)
        
        hola.font = UIFont(name: "herne1.ttf", size: 16.0)
        namelabel.font = UIFont(name: "herne1.ttf", size: 16.0)
        leyendalabel.font = UIFont(name: "herne1.ttf", size: 16.0)*/
        /*let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self)
        menuLeftNavigationController.leftSide = true
        
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)*/
        
        /*SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "derechomenu") as? UISideMenuNavigationController*/
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        //SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        //SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        //refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        //refreshControl.addTarget(self, action: "refresh:", for: UIControlEvents.valueChanged)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableview.addSubview(refreshControl)
        
        //get userdafyltsvale
        //self.getJson(telefon:"userdafutls")
        
        if actualizar == "1"{
            actualizar = "0"
            DispatchQueue.global(qos: .userInitiated).async {
            if let cel = UserDefaults.standard.value(forKey: "celular") {
                celular = cel as! String
                self.getJson(telefon: celular)
                //getJson(telefon: celular, vistafrom: self);
                }
            }
        }else {
            uploadDataFromDB()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         let location = locations[0]
         
         //speed = String(location.speed)
         //print(speed)
         
         valornum = Double(location.speed)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadDataFromDB(){
        arreglo = [[String:String]]()
        arregloPolizas = [[String:String]]()
        arreglocarro = [[String:String]]()
        
        //print("Herefisrt")
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            //request for  tables
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let requestpoli = NSFetchRequest<NSFetchRequestResult>(entityName: "Polizas")
            //requestpoli.sortDescriptors = [NSSortDescriptor(key: "reportstate", ascending: true)]
            requestpoli.sortDescriptors = [NSSortDescriptor(key: "reportstate", ascending: false)]
            
            let requestcarro = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehiculos")
            //let results = context.fetch(request)
            request.returnsObjectsAsFaults = false
            //requestpoli.returnsObjectsAsFaults = false
            requestcarro.returnsObjectsAsFaults = false
            
            if #available(iOS 10.0, *) {
            let context = appDelegate.persistentContainer.viewContext
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
                        nombrecliente = username
                        
                        //Asignamos nombre de ususaro a pantalla
                        labelnombre.text = username
                        //arreglo.setValue(username, forKey: "name")
                        //print(result.value(forKey: "lastname") as? String)
                        tempdict["lastname"] = result.value(forKey: "lastname") as? String
                        tempdict["mothername"] = result.value(forKey: "lastname") as? String
                        tempdict["token"] = result.value(forKey: "token") as? String
                        tempdict["celphone"] = result.value(forKey: "celphone") as? String
                        celular = (result.value(forKey: "celphone") as? String)!

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
                        let pay = result.value(forKey: "payment") as? String
                        let fecha = result.value(forKey: "limitefecha") as? Date
                        
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
                        tempdict2["payment"] = pay//result.value(forKey: "vehiclepie") as? String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                        let dateStringfin = dateFormatter.string(from:fecha!)
                        //let lastdate = fecha?.description.components(separatedBy: " ")
                        //dateFormatter.dateFormat = "yyyy-mm-dd"
                        //let newDate = dateFormatter.date(from: (lastdate?[0])!)
                        tempdict2["limitefecha"] = dateStringfin
                        
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
            } else {
                // Fallback on earlier versions
                showmessage(message: "Actualiza iOS para ver las mejoras del sistema.")
            }
        } catch {
            print("Couldn't fetch results")
        }
        
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        flagcontrol = "0"
        print("refreshing")
        if let cel = UserDefaults.standard.value(forKey: "celular") {

            DispatchQueue.global(qos: .userInitiated).async {
                celular = cel as! String
                self.getJson(telefon: celular)
                //getJson(telefon: celular, vistafrom: self);
            }
        }
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Return the number of rows in our table
        //print("Tmaanio:\(arregloPolizas.count)")
        return arregloPolizas.count
    }
    
    func getDocumentsDirectory() -> URL {
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

// ******************************** show image when clic on image ********************************** //
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
    
// ******************************** full image when clic on image ********************************** //
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

// ******************************** initializes every row of th table ******************************** //
    func compressImage(image:UIImage) -> UIImage {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = image.size.height/16//300
        var maxWidth : CGFloat = image.size.width/16//400.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 1
        
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
        //let imageData = UIImagePNGRepresentation(img!);
        //UIGraphicsEndImageContext();
        
        return img!;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
// ******************************** initializes every row of th table ******************************** //
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Define el contenido de la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PolizasTableViewCell

        //DispatchQueue.global(qos: .userInitiated).async {

            //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))

            //DispatchQueue.main.async(execute: {

                tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
                
                //cell.imagecar.isUserInteractionEnabled = true
                //cell.imagecar.addGestureRecognizer(tapGestureRecognizer)
                
                //set picture loaded
                let pliza = arregloPolizas[indexPath.row]["nopoliza"]! as String
                let fileManager = FileManager.default
                let filename = self.getDocumentsDirectory().appendingPathComponent("frontal_\(pliza).png")
                if fileManager.fileExists(atPath: filename.path){
                    
                    let image = UIImage(contentsOfFile: filename.path)
                    //let comrimidad = self.compressImage(image: image!)
                    cell.imagecar.layer.cornerRadius = 30.0
                    //if volteado == "0"{
                        //volteado = "1"
                        //cell.imagecar.transform = cell.imagecar.transform.rotated(by: CGFloat(Double.pi/2))
                    //}
                    cell.imagecar.layer.masksToBounds = true
                    cell.imagecar.image = image
                }else{
                    //print("No existe foto")
                    let image = UIImage(named: "foto.png")
                    cell.imagecar.layer.cornerRadius = 20.0
                    //cell.imagecar.transform = cell.imagecar.transform.rotated(by: CGFloat(Double.pi/2))
                    cell.imagecar.layer.masksToBounds = true
                    cell.imagecar.image = image
                }
                
                //Set value to poliza
                cell.label.text = "Póliza: \(arregloPolizas[indexPath.row]["nopoliza"]! as String)"
                
                //Get value from reporstate and then set color in the icon
                let reportstate = arregloPolizas[indexPath.row]["reportstate"]! as String
                let odometerpie = (arregloPolizas[indexPath.row]["odometerpie"]! as String)
                let vehiclepie = (arregloPolizas[indexPath.row]["vehiclepie"]! as String)
                
                if reportstate == "15" {
                    //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    //UIColor.red
                    cell.imageicon.backgroundColor = UIColor.red
                    cell.labelalerta.textColor = UIColor.red
                    cell.labelalerta.text = "Solicitud ajuste odómetro \(arreglocarro[indexPath.row]["subtype"]! as String)"
                    cell.mensajelimite.isHidden = true

                }
                if reportstate == "14" {
                    //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    //UIColor.red
                    cell.imageicon.backgroundColor = UIColor.red
                    cell.labelalerta.textColor = UIColor.red
                    cell.labelalerta.text = "Solicitud cancelación voluntaria \(arreglocarro[indexPath.row]["subtype"]! as String)"
                    cell.mensajelimite.isHidden = true

                }
                if reportstate == "13" {
                    //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    cell.imageicon.backgroundColor = UIColor.red
                    cell.labelalerta.textColor = UIColor.red
                    
                    //UIColor.red
                    cell.labelalerta.text = "Es hora de reportar tu odómetro \(arreglocarro[indexPath.row]["subtype"]! as String)"
                    cell.mensajelimite.isHidden = true
                    
                    let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let date = dateFormatter.date(from: dateString)
                    
                    //get name month
                    let dateFormattermes = DateFormatter()
                    dateFormattermes.dateFormat = "MMM"
                    let nameOfMonthcinco = dateFormattermes.string(from: date!)
                    let valmes = getNombreMes(nombre: nameOfMonthcinco)
                    dateFormattermes.dateFormat = "dd"
                    let valdia = dateFormattermes.string(from: date!)
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date!)
                    let minutes = calendar.component(.minute, from: date!)
                    let seconds = calendar.component(.second, from: date!)
                    
                    cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) del \(valmes) a las \(hour):\(minutes) hrs."
                    cell.mensajelimite.textColor = UIColor.red
                    cell.mensajelimite.isHidden = false
                }
                if reportstate == "12" {
                    cell.imageicon.backgroundColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)
                    cell.labelalerta.textColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)
                    //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
                    
                    //cell.labelalerta.textColor = UIColor.init(red: 0.0, green: 200.0, blue: 255.0, alpha: 1.0)
                    cell.labelalerta.text = "Ver información \(arreglocarro[indexPath.row]["subtype"]! as String)"
                    cell.mensajelimite.isHidden = true
                }
                if vehiclepie == "false" && odometerpie == "false"{
                    //cell.imageicon.backgroundColor = UIColor.green
                    cell.imageicon.backgroundColor = UIColor.red
                    cell.labelalerta.textColor = UIColor.red
                    cell.labelalerta.text = "No has enviado fotos de tu \(arreglocarro[indexPath.row]["subtype"]! as String)"
                    
                    let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let date = dateFormatter.date(from: dateString)
                    
                    //get name month
                    let dateFormattermes = DateFormatter()
                    dateFormattermes.dateFormat = "MMM"
                    let nameOfMonthcinco = dateFormattermes.string(from: date!)
                    let valmes = getNombreMes(nombre: nameOfMonthcinco)
                    dateFormattermes.dateFormat = "dd"
                    let valdia = dateFormattermes.string(from: date!)
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date!)
                    let minutes = calendar.component(.minute, from: date!)
                    let seconds = calendar.component(.second, from: date!)
                    
                    cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) del \(valmes) a las \(hour):\(minutes) hrs."
                    cell.mensajelimite.textColor = UIColor.red

                    cell.mensajelimite.isHidden = false
                }
                if vehiclepie == "true" && odometerpie == "false"{
                    //cell.imageicon.backgroundColor = UIColor.green
                    cell.imageicon.backgroundColor = UIColor.red
                    cell.labelalerta.textColor = UIColor.red
                    cell.labelalerta.text = "No has enviado foto de tu odómetro \(arreglocarro[indexPath.row]["subtype"]! as String)"
                    
                    let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let date = dateFormatter.date(from: dateString)
                    
                    //get name month
                    let dateFormattermes = DateFormatter()
                    dateFormattermes.dateFormat = "MMM"
                    let nameOfMonthcinco = dateFormattermes.string(from: date!)
                    let valmes = getNombreMes(nombre: nameOfMonthcinco)
                    dateFormattermes.dateFormat = "dd"
                    let valdia = dateFormattermes.string(from: date!)
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date!)
                    let minutes = calendar.component(.minute, from: date!)
                    let seconds = calendar.component(.second, from: date!)
                    
                    cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) del \(valmes) a las \(hour):\(minutes) hrs."
                    cell.mensajelimite.textColor = UIColor.red
                    cell.mensajelimite.isHidden = false
                }
                
                //cell background
                cell.contentView.backgroundColor = UIColor.white
                
                let whiteRoundedView : UIView = UIView(frame: CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
                
                //whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                whiteRoundedView.layer.masksToBounds = false
                whiteRoundedView.layer.cornerRadius = 2.0
                whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                whiteRoundedView.layer.shadowOpacity = 0.2
                
                cell.contentView.addSubview(whiteRoundedView)
                cell.contentView.sendSubview(toBack: whiteRoundedView)
                
            //})
        //}
        return cell
    }

    func getNombreMes(nombre: String) -> String{
        if nombre == "ene" || nombre == "Jan" || nombre == "jan" || nombre == "Ene"{
            return "enero"
        }else if nombre == "feb" || nombre == "Feb"{
            return "febrero"
        }else if nombre == "mar" || nombre == "Mar"{
            return "marzo"
        }else if nombre == "abr" || nombre == "apr" || nombre == "Apr"{
            return "abril"
        }else if nombre == "may" || nombre == "May"{
            return "mayo"
        }else if nombre == "jun" || nombre == "Jun"{
            return "junio"
        }else if nombre == "jul" || nombre == "Jul"{
            return "julio"
        }else if nombre == "ago" || nombre == "aug" || nombre == "Aug" || nombre == "Ago"{
            return "agosto"
        }else if nombre == "sep" || nombre == "Sep"{
            return "septiembre"
        }else if nombre == "oct" || nombre == "Oct"{
            return "octubre"
        }else if nombre == "nov" || nombre == "Nov"{
            return "noviembre"
        }else if nombre == "dic" || nombre == "dec" || nombre == "Dic" || nombre == "Dec"{
            return "diciembre"
        }else{
            return nombre
        }
    }
/*************************************************************************************************
     When clic in row -> open detalle poliza / fotos 
     It's upon the status fotos
************************************************************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! PolizasTableViewCell
        currentCell.contentView.backgroundColor = UIColor.white
        currentCell.backgroundColor = UIColor.white
        
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
        
        if valornum >= 10.0 {
            //print("lanzamos alerta")
            let refreshAlert = UIAlertController(title: "¡Vas Manejando!", message: "Reporta más tarde…", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.tableview.reloadData()

                //self.launcpolizas()
            }))
            present(refreshAlert, animated: true, completion: nil)
        } else {
            
            /*do{

            let image = UIImage(named: "logoatlas.png")
            let photo = Photo(image: image!, userGenerated: true)
            let content = PhotoShareContent(photos: [photo])
            let shareDialog = ShareDialog(content: content)
            shareDialog.mode = .automatic
            shareDialog.failsOnInvalidData = true
            shareDialog.completion = { result in
                // Handle share results
            }
            
            try shareDialog.show()
            }catch {
            }*/
            
            /*let screen = UIScreen.main
            let imag = UIImage(named: "logoatlas.png")
            let frame = CGRect(x: 0, y: 0, width: (imag?.size.width)!, height: (imag?.size.height)!)
            
            if let window = UIApplication.shared.keyWindow {
                UIGraphicsBeginImageContextWithOptions((imag?.size)!, false, 0);
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
                let image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: image!, instagramCaption: "Gracias!", view: self.view)
                let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                composeSheet?.setInitialText("Gracias por ser parte del consumo equitativo.!")
                composeSheet?.add(imag)
                
                present(composeSheet!, animated: true, completion: nil)
            }*/
            
            //prueba compartir

            //let imag = UIImage(named: "miituo.png")
            //InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: imag!, instagramCaption: "Gracias!", view: self.view)

            
            //let imag = UIImage(named: "miituo.png")
            //InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: imag!, instagramCaption: "Gracias!", view: self.view)

            //let activityVC = UIActivityViewController(activityItems:[imag,"Gracias por ser parte del consumo equitativo."], applicationActivities:nil)
            //activityVC.popoverPresentationController?.sourceView = self.view
            //self.present(activityVC, animated: true, completion: nil)
            
            //check the options to show the specific viewcontroller
            if vehiclepie == "false" && odometerpie == "false" {
                currentCell.imageicon.backgroundColor = UIColor.red
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoscar") as! PhotosCarViewController
                //vc.cadenas = valueToPass
                self.present(vc, animated: true, completion: nil)
            }else if vehiclepie == "true" && odometerpie == "false" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "first"
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
                //vc.cadenas = valueToPass
                self.present(vc, animated: true, completion: nil)
                //first validte repotstate
            }else if reportstate == "13" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "mensual"
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
                //vc.cadenas = valueToPass
                self.present(vc, animated: true, completion: nil)
            }else if reportstate == "14" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "cancela"
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
                //vc.cadenas = valueToPass
                self.present(vc, animated: true, completion: nil)
            }else if reportstate == "15" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "ajuste"
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
                //vc.cadenas = valueToPass
                self.present(vc, animated: true, completion: nil)
            }
            else {
                currentCell.imageicon.backgroundColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)

                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarview") //as! DetallePolizaViewController
                //vc.cadenas = valueToPass
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

//*******************Function to get data with the celphone*********************************************
    func getJson(telefon:String){
        //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {

        print("getjson: \(telefon)")
        
        let url = URL(string: "\(ip)InfoClientMobil/Celphone/"+telefon)!
        let session = URLSession.shared
        let loadTask = session.dataTask(with: url){(data,response,error) in
            if error != nil {
                showmessage(message: "Error de conexión. Intente más tarde...")
                DispatchQueue.main.async {
                
                    self.refreshControl.endRefreshing()
                }

                flagcontrol = "2"

            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                    print("error \(httpResponse.description)")

                    if httpResponse.statusCode == 200{
                        if let str = String(data: data!, encoding: String.Encoding.utf8) {
                            print("Valor de retorno: \(str)")
                            valordevuelto = str
                            if let urlContent = data{
                                
                                do{
                                    let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                    
                                    guard let temp = json.value(forKey: "Client") else{
                                        //print(temp)
                                        print("error")
                                        DispatchQueue.main.async {
                                            
                                            alertaloading?.dismiss(animated: true, completion: {
                                                //launchpolizas(vista: vistafrom)
                                                //Alerta con mensaje de error
                                                let refreshAlert = UIAlertController(title: "Atención", message: "Error al actualizar información. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                                                
                                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                    
                                                    //})
                                                }))
                                                
                                                self.present(refreshAlert, animated: true, completion: nil)
                                            })
                                        }
                                        return
                                    }
                                    
                                    tienepolizas = "si"

                                    DispatchQueue.main.async {
                                        self.saveCoreData(json: json, telefon: telefon)
                                    }
                                    /*DispatchQueue.main.sync {
                                        //self.saveCoreData(json: json, telefon: telefon)
                                        self.uploadDataFromDB()
                                        self.tableview.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }*/
                                    
                                    //self.saveCoreData(json: json, telefon: telefon)
                                    //DispatchQueue.main.async {
                                    //}
                                    
                                    /*flagcontrol = "1"
                                    DispatchQueue.main.async {
                                        self.uploadDataFromDB()
                                        self.tableview.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }*/
                                    
                                } catch{
                                    showmessage(message: "Error en JSON datos polizas.")
                                }
                            }   //End if
                        }
                    }else{
                        do {
                            guard let receivedTodo = try JSONSerialization.jsonObject(with: data!,
                                                                                      options: []) as? [String: Any] else {
                                                                                        print("Could not get JSON from responseData as dictionary")
                                                                                        return
                            }
                            print("The todo is: " + receivedTodo.description)
                            jsoncorrecto = "0"
                            //Disparamos error y regresamos a polzias
                            DispatchQueue.main.async {
                                
                                let mess = receivedTodo["Message"] as! String
                                
                                if mess.contains("null")
                                {
                                    self.refreshControl.endRefreshing()
                                    //alertaloading?.dismiss(animated: true, completion: {
                                    
                                    let prefs = UserDefaults.standard
                                    prefs.removeObject(forKey:"tutoya")
                                    prefs.removeObject(forKey:"tutoya")
                                    prefs.removeObject(forKey:"celular")
                                    
                                    //open mainactivity
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let myAlert = storyboard.instantiateViewController(withIdentifier: "flash") as! SplashViewController
                                    
                                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                    
                                    //launch second view with data - show table and polizas
                                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                    self.present(myAlert, animated: true, completion: nil)
                                    
                                    //})
                                    
                                }else{
                                    showmessage(message: receivedTodo["Message"] as! String)
                                    self.refreshControl.endRefreshing()
                                    //self.tableview.clear
                                    alertaloading?.dismiss(animated: true, completion: {
                                        
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
        //})
    }
    
/*********************** launch polizas***************************************************/
    func saveCoreData(json: AnyObject, telefon: String){
        
        //store do core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
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
                    //let tokene = (cli["Token"] as! String).description
                    let tokene = ""
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
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
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

                    let pay = (poli["PaymentType"] as! String).description
                    newPoli.setValue(pay, forKey: "payment")

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
            
             DispatchQueue.main.sync {
                 //self.saveCoreData(json: json, telefon: telefon)
                 self.uploadDataFromDB()
                 self.tableview.reloadData()
                 self.refreshControl.endRefreshing()
             }
        }            
        } else {
            // Fallback on earlier versions
            showmessage(message: "Actualiza iOS para ver las mejoras del sistema.")
        }
    }
    
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }*/
}

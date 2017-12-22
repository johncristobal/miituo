//
//  DetalleViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 29/05/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit
import Foundation

class DetalleViewController: UIViewController {

    @IBOutlet var fecha: UILabel!
    @IBOutlet var fechaabajo: UILabel!    
    @IBOutlet var arriba: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        print("Ancho: \(screenWidth)")
        print("Alto: \(screenHeight)")
        if screenHeight > 560 {
            arriba.constant = 110
        }
        if screenHeight > 660 {
            arriba.constant = 145
        }
        if screenHeight > 730 {
            arriba.constant = 160
        }
        // Do any additional setup after loading the view.
        
        //fecha.text = "Tu siguiente reporte será el: \(arregloPolizas[Int(valueToPass)!]["limitefecha"]! as String)"
        
        //let dateString = "2014-07-15" // change to your date format
        let dateString = arregloPolizas[Int(valueToPass)!]["limitefecha"]! as String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dateaux = dateFormatter.date(from: dateString)
        let date = Calendar.current.date(byAdding: .day, value: -1, to: dateaux!)

        //get name month
        let dateFormattermes = DateFormatter()
        dateFormattermes.dateFormat = "MMM"
        let nameOfMonthcinco = dateFormattermes.string(from: date!)
        let valmes = getNombreMes(nombre: nameOfMonthcinco)
        dateFormattermes.dateFormat = "dd"
        let valdia = dateFormattermes.string(from: date!)
        dateFormattermes.dateFormat = "yyyy"
        let valanio = dateFormattermes.string(from: date!)
        fechaabajo.text = "al \(valdia) de \(valmes)"
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: -4, to: dateaux!)
        dateFormattermes.dateFormat = "MMM"
        let nameOfMonthantes = dateFormattermes.string(from: tomorrow!)
        let valmesb = getNombreMes(nombre: nameOfMonthantes)
        dateFormattermes.dateFormat = "dd"
        let valdiab = dateFormattermes.string(from: tomorrow!)
        dateFormattermes.dateFormat = "yyyy"
        let valaniob = dateFormattermes.string(from: date!)
        fecha.text = "del \(valdiab) de \(valmesb)"

        //let fechare = dateFormatter.string(from: tomorrow!)
        
        //fecha.text = "Tu siguiente reporte será del \(fechare) al \(dateString)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AcercaViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 01/06/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class AcercaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cadenashere = ["Aviso de privacidad"]
    
    @IBOutlet var webvista: UIWebView!
    @IBOutlet var menuButton: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let data = "<!DOCTYPE html>\n" +
            "<!--\n" +
            "To change this license header, choose License Headers in Project Properties.\n" +
            "To change this template file, choose Tools | Templates\n" +
            "and open the template in the editor.\n" +
            "-->\n" +
            "<html>\n" +
            "    <head>\n" +
            "        <title>TODO supply a title</title>\n" +
            "        <meta charset=\"UTF-8\">\n" +
            "        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
            "        <style>\n" +
            "            @font-face {\n" +
            "                font-family: 'feast';\n" +
            "                src: url('fonts/herne1.ttf');\n" +
            "            }\n" +
            "\n" +
            "            body {font-family: 'DIN Next Rounded LT Pro';}\n" +
            "        </style>\n" +
            "    </head>\n" +
            "    <body>\n" +
            "        <div>\n" +
            "            <h4>Si manejas poco, pagas poco.</h4>\n" +
            "            <p align=\"left\">\n" +
            "            El único seguro de autos que te ofrece pago por kilómetro.\n" +
            "            <br><br>\n" +
            "            En <b>miituo</b> hemos creado un seguro de auto donde solamente pagas por kilómetro recorrido.  \n" +
            "            Es muy fácil, tu tarifa es por kilómetro por lo que solamente pagas por lo que recorriste durante el mes y no \n" +
            "            importa si solamente fue 1 o 1,000 kilómetros ya que siempre estarás cubierto con alguno de nuestros planes \n" +
            "            (amplio, limitado o responsabilidad civil).\n" +
            "            <br><br>\n" +
            "            Nuestra tarifa es fácil y clara.\n" +
            "            <br><br>\n" +
            "            Con base en la información que nos proporciones, nuestros algoritmos calcularán una prima por kilómetro. \n" +
            "            Esta será fija durante los doce meses de vigencia de la póliza y se multiplicará por los kilómetros que \n" +
            "            recorriste durante el mes. \n" +
            "\n" +
            "            <br><br>\n" +
            "            Independientemente de los kilómetros que recorriste, siempre estarás cubierto con tu seguro de auto <b>miituo</b>.\n" +
            "\n" +
            "            <br><br>\n" +
            "            ¡Asi de Fácil!\n" +
            "            </p>\n" +
            "\n" +
            "        </div>\n" +
            "    </body>\n" +
        "</html>\n";
        
        webvista.loadHTMLString(data, baseURL: nil)
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

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Return the number of rows in our table
        //return 1
        return cadenashere.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Define el contenido de la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;

        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = cadenashere[indexPath.row]   //"Aviso de privacidad"
        
        print("Valor fila: \(indexPath.row)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Here: \(indexPath.row)")
        let currentCell = tableView.cellForRow(at: indexPath)! //as! PolizasTableViewCell
        currentCell.contentView.backgroundColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)
        currentCell.backgroundColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)

        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacidad") as! PrivacidadViewController
            //vc.cadenas = valueToPass
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//
//  MenuNewViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 29/06/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class MenuNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var nombreLabel: UILabel!
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;

        if indexPath.row == 0{
            cell.optionlabel.text = "Tus pólizas"
            cell.imageicon.image = UIImage(named: "ico_poliza.png")
        }else if indexPath.row == 1{
            cell.optionlabel.text = "Acerca de"
            cell.imageicon.image = UIImage(named: "ico_ayuda.png")
        }else if indexPath.row == 2{
            cell.optionlabel.text = "Cotiza"
            cell.imageicon.image = UIImage(named: "icon_cotiza.png")
        }
        
        return cell
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombreLabel.text = nombrecliente

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
            
            //myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            //launch second view with data - show table and polizas
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
            present(myAlert, animated: true, completion: nil)

            //print("0")
            //dismiss(animated: true, completion: nil)
        }else if indexPath.row == 1{
            //print("1")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "revealAcerca") as! SWRevealViewController
            myAlert.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            present(myAlert, animated: true, completion: nil)
            
        }else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "cotiza") as!  CotizaViewController
            myAlert.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            present(myAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print(segue.description)
    }
    
    
    @IBAction func closeSesion(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "fourSB") as! ViewController
        
        let refreshAlert = UIAlertController(title: "Atención", message: "¿Desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = (UIAlertAction(title: "Sí", style: .default, handler: { (action: UIAlertAction!) in
            
            print("Cerrando...")
            
            //DispatchQueue.global(qos: .userInitiated).async {
            //   DispatchQueue.main.async {
            
            //self.dismiss(animated: true, completion: nil)
            //self.dismiss(animated: true, completion: {
            
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey:"tutoya")
            prefs.removeObject(forKey:"celular")
            prefs.removeObject(forKey:"sesion")
            
            //myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            //myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(myAlert, animated: true, completion: nil)
            //})
            //}
            //}
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
            print("Nada...")
            
        }))
        
        refreshAlert.addAction(action)
        present(refreshAlert, animated: true)
        
    }

}

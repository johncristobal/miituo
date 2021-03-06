//
//  PerfilViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 24/04/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var imagencarro: UIImageView!
    
    @IBOutlet weak var carrolabel: UILabel!
    @IBOutlet weak var polizalabel: UILabel!
    @IBOutlet weak var placaslabel: UILabel!
    
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    
    var cells: SwiftyAccordionCells!

    override func viewDidLoad() {
        //super.viewDidLoad()

        // Do any additional setup after loading the view.
        cells = SwiftyAccordionCells()
        self.setup()
        self.table.estimatedRowHeight = 45
        self.table.rowHeight = UITableViewAutomaticDimension
        
        carrolabel.text = arreglocarro[Int(valueToPass)!]["descripcion"] as! String
        
        polizalabel.text = arregloPolizas[Int(valueToPass)!]["nopoliza"] as! String
        
        placaslabel.text = ""
        
        //set picture loaded
        let pliza = arregloPolizas[Int(valueToPass)!]["nopoliza"]! as String
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("frontal_\(pliza).png")
        if fileManager.fileExists(atPath: filename.path){
            let image = UIImage(contentsOfFile: filename.path)
            imagencarro.layer.cornerRadius = 25.0
            //imagencarro.transform = imagencarro.transform.rotated(by: CGFloat(Double.pi/2))
            imagencarro.layer.masksToBounds = true
            imagencarro.image = image
        } else {
            print("No existe foto")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.table.reloadData()
    }
    
    func setup() {
        //self.enter.layer.cornerRadius = 4
        
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Tu información"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Nombre: \(arreglo[Int(0)]["name"]!)"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Celular: \(arreglo[Int(0)]["celphone"]!)"))
        /*self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 2"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 3"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 4"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 5"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 6"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 7"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 8"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 9"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 10"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 11"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 12"))*/
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Tu auto"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Placas: \(arreglocarro[Int(valueToPass)!]["plates"]!)"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Modelo: \(arreglocarro[Int(valueToPass)!]["model"]!)"))
        /*self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 1"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 2"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 3"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 4"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 5"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 6"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 7"))*/
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Tu odómetro"))
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let odomtemp = arregloPolizas[Int(valueToPass)!]["lastodometer"]
        //let decim = Double(odomtemp!)
        //let suma = Int((odomtemp?.description)!)! + 0
        let lastodo = numberFormatter.string(from: NSNumber(value: Int(odomtemp!)!))
        //let int = Int((lastodo?.description)!)
        
        if let unwrappedAge = lastodo {
            
            // continue in here
            self.cells.append(SwiftyAccordionCells.Item(value: "Último odómetro: \(unwrappedAge)"))
            
        }else{
            self.cells.append(SwiftyAccordionCells.Item(value: "Último odómetro: \(lastodo)"))
        }
        //self.cells.append(SwiftyAccordionCells.Item(value: "Último odómetro: \(arregloPolizas[Int(valueToPass)!]["lastodometer"]!)"))
        /*self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 1"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 2"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 3"))*/
        
        //self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Tu cobertura"))
        //self.cells.append(SwiftyAccordionCells.Item(value: arreglocarro[Int(valueToPass)!]["plates"]!))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        let value = item.value
        let isChecked = item.isChecked as Bool
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = value
            
            if item as? SwiftyAccordionCells.HeaderItem != nil {
                //cell.backgroundColor = UIColor.lightGray
                cell.imageView?.image = UIImage(named: "blackflecha.png")
                
                cell.accessoryType = .none
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.font = UIFont(name: "DIN Next Rounded LT Pro", size: 21.0)
                cell.textLabel?.textColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.font = UIFont(name: "DIN Next Rounded LT Pro", size: 18.0)
                if isChecked {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            return 60
        } else if (item.isHidden) {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.white
        cell?.backgroundColor = UIColor.white

        let item = self.cells.items[(indexPath as NSIndexPath).row]

        if item is SwiftyAccordionCells.HeaderItem {

            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cells.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cells.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            
            self.table.beginUpdates()
            self.table.endUpdates()
            
        } else {
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.table.cellForRow(at: indexPath)
                //cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                cell?.backgroundColor = UIColor.white
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let previousCell = self.table.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0))
                    previousCell?.accessoryType = UITableViewCellAccessoryType.none
                    previousCell?.backgroundColor = UIColor.white

                    cells.items[selectedItemIndex].isChecked = false
                }
                
                self.selectedItemIndex = (indexPath as NSIndexPath).row
                cells.items[self.selectedItemIndex!].isChecked = true
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

}

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
        self.cells.append(SwiftyAccordionCells.Item(value: "Nombre: \(arreglo[Int(valueToPass)!]["name"]!)"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Celular: \(arreglo[Int(valueToPass)!]["celphone"]!)"))
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
        self.cells.append(SwiftyAccordionCells.Item(value: "Modelo: \(arreglocarro[Int(valueToPass)!]["model"]!)"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Placas: \(arreglocarro[Int(valueToPass)!]["plates"]!)"))
        /*self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 1"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 2"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 3"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 4"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 5"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 6"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 7"))*/
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Tu odómetro"))
        /*self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 1"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 2"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 3"))*/
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Tu cobertura"))
        self.cells.append(SwiftyAccordionCells.Item(value: arreglocarro[Int(valueToPass)!]["plates"]!))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 2"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 3"))
        self.cells.append(SwiftyAccordionCells.Item(value: "Sub Item 4"))
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
                cell.accessoryType = .none
                cell.textLabel?.textColor = UIColor(red: CGFloat((00 & 0xFF0000) >> 16) / 255.0, green: CGFloat((200 & 0x00FF00) >> 8) / 255.0, blue: CGFloat((255 & 0x0000FF)) / 255.0, alpha: CGFloat(1.0))
            } else {
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.textColor = UIColor.black
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
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = UIColor.clear

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

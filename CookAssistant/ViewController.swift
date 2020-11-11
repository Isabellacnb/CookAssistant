//
//  ViewController.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 16/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit
class ViewController: UIViewController,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    

    //@IBOutlet weak var tableViewRecipes: UITableView!
    @IBOutlet weak var tfIngrediente: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tableViewIngrediente: UITableView!
    @IBOutlet weak var stCantidad: UIStepper!
    @IBOutlet weak var addIngredient: UIButton!
    @IBOutlet weak var btnMeasure: UIButton!
    @IBOutlet weak var tableViewMeasures: UITableView!
    
    var arrayMeasures : NSMutableArray = ["tsp", "tbsp", "oz", "cups", "pints", "qrts", "gal"]

    var idMeasure = 0
    var listaIngredientes : [Ingrediente] = []
    //var listaRecetas : [Receta] = []
    //var listaRecetasFavoritas : [Receta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMeasures.delegate = self
        tableViewMeasures.dataSource = self
        
        // Agregar logo al navigation bar
        let imageV = UIImageView(image: #imageLiteral(resourceName: "cookAssistantLogo"))
        imageV.frame = CGRect(x: 0, y: 0, width: 170, height: 42)
        imageV.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 42))
        titleView.addSubview(imageV)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
    
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)         // Do any additional setup after loading the view.
        listaIngredientes = []
        self.navigationController!.navigationBar.isHidden = false
        // Ingredientes
        tfCantidad.text = "0"
        stCantidad.value = 0
        
        // Tableview measurements
        btnMeasure.backgroundColor = UIColor.white
        btnMeasure.layer.cornerRadius = 5
        btnMeasure.layer.borderWidth = 1
        btnMeasure.layer.borderColor = UIColor.black.cgColor
        btnMeasure.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        tableViewMeasures.backgroundColor = UIColor.white
        tableViewMeasures.layer.cornerRadius = 5
        tableViewMeasures.layer.borderWidth = 1
        tableViewMeasures.layer.borderColor = UIColor.black.cgColor
        
        tableViewMeasures.isHidden = true

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Mark: - Agregar ingredientes
    
    @IBAction func agregarIngrediente(_ sender: UIButton) {
        if (sender == addIngredient) {
            if(tfIngrediente.text != "" && Int(tfCantidad.text!) != nil && Int(tfCantidad.text!)! > 0 && idMeasure > 0) {
                let ingr = Ingrediente(nombre: tfIngrediente.text!, cantidad: Int(tfCantidad.text!)!, medida: idMeasure)
                listaIngredientes.append(ingr)
                tableViewIngrediente.reloadData()
                
                // Limpiar textfields
                tfIngrediente.text = ""
                tfCantidad.text = "0"
                stCantidad.value = 0
                btnMeasure.setTitle("----", for: UIControl.State.normal)
                btnMeasure.setTitleColor(UIColor.black, for: UIControl.State.normal)

                
            } else {
                let alerta = UIAlertController(title: "ERROR", message: "Complete all ingredient information to add new ingredient (name, quantity and measurement)", preferredStyle: .alert)
                let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alerta.addAction(accion)
                present(alerta, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        if(Int(tfCantidad.text!) != nil) {
            tfCantidad.text = String(Int(stCantidad.value))
        }
    }
    
    @IBAction func cambioManualCantidad(_ sender: Any) {
        if(Int(tfCantidad.text!) != nil) {
            stCantidad.value = Double(tfCantidad.text!)!
        }
    }
    
    // MARK: - Métodos de Table View Data Source INGREDIENTES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == tableViewIngrediente) {
            return listaIngredientes.count
        } else if (tableView == tableViewMeasures) {
            return arrayMeasures.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewIngrediente {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaIngrediente")!
            
            celda.textLabel?.text = listaIngredientes[indexPath.row].nombre
            celda.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
            let valorMedida = arrayMeasures[ listaIngredientes[indexPath.row].medida - 1]
            let strMedida = valorMedida as! String
            let detalle = String(listaIngredientes[indexPath.row].cantidad) + " " + strMedida
            celda.detailTextLabel?.text = detalle
            
            return celda
        } else {
            let celda = tableView.dequeueReusableCell(withIdentifier: "cellM")
            celda?.textLabel?.text = (arrayMeasures[indexPath.row] as! String)
            return celda!
        }
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (tableView == tableViewIngrediente) {
            return true
        } else {
            return false
        }
        // Return false if you do not want the specified item to be editable.
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (tableView == tableViewIngrediente) {
            if editingStyle == .delete {
                // Delete the row from the data source
                listaIngredientes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        
    }
    

    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if (tableView == tableViewIngrediente) {
            let tmp = listaIngredientes[fromIndexPath.row]
            listaIngredientes[fromIndexPath.row] = listaIngredientes[to.row]
            listaIngredientes[to.row] = tmp
        }
        

    }
    

    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if (tableView == tableViewIngrediente) {
            return true
        } else {
            return false
        }
    }
    
    // Mostrar dropdown de measures
    @IBAction func btnSelectMeasure(_ sender: Any) {
        if tableViewMeasures.isHidden == true {
            tableViewMeasures.isHidden = false
        } else {
            tableViewMeasures.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
            if tableView == tableViewMeasures {
                let selectedItem = arrayMeasures[indexPath.row] as! String
                btnMeasure.setTitle(selectedItem, for: UIControl.State.normal)
                if selectedItem == "tsp" {
                    idMeasure = 1
                } else if selectedItem == "tbsp"{
                    idMeasure = 2
                } else if selectedItem == "oz" {
                    idMeasure = 3
                } else if selectedItem == "cups" {
                    idMeasure = 4
                } else if selectedItem == "pints" {
                    idMeasure = 5
                } else if selectedItem == "quarts" {
                    idMeasure = 6
                } else if selectedItem == "gal" {
                    idMeasure = 7
                }
                tableViewMeasures?.isHidden = true
                btnMeasure.setTitle(selectedItem, for: UIControl.State.normal)

            }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewMeasures {
            return 20
        } else {
            return 45
        }
    }

    
}


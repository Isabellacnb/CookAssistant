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
    

    
    var listaIngredientes : [Ingrediente] = []
    //var listaRecetas : [Receta] = []
    //var listaRecetasFavoritas : [Receta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Agregar logo al navigation bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "cookAssistantLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)         // Do any additional setup after loading the view.
        listaIngredientes = []
        self.navigationController!.navigationBar.isHidden = false
        // Ingredientes
        tfCantidad.text = "0"
        stCantidad.value = 0

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Mark: - Agregar ingredientes
    
    @IBAction func agregarIngrediente(_ sender: UIButton) {
        if (sender == addIngredient) {
            if(tfIngrediente.text != "" && Int(tfCantidad.text!) != nil && Int(tfCantidad.text!)! > 0) {
                let ingr = Ingrediente(nombre: tfIngrediente.text!, cantidad: Int(tfCantidad.text!)!)
                listaIngredientes.append(ingr)
                tableViewIngrediente.reloadData()
                
                // Limpiar textfields
                tfIngrediente.text = ""
                tfCantidad.text = "0"
                stCantidad.value = 0
            } else {
                let alerta = UIAlertController(title: "ERROR", message: "Completar todos los datos", preferredStyle: .alert)
                let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alerta.addAction(accion)
                present(alerta,animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == tableViewIngrediente) {
            return  listaIngredientes.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaIngrediente")!
        
        celda.textLabel?.text = listaIngredientes[indexPath.row].nombre
        celda.detailTextLabel?.text = String(listaIngredientes[indexPath.row].cantidad)
        
        return celda
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
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addRecipe" {

            print(listaRecetas)
            let vistaAgregar = segue.destination as! AddRecipeViewController
            vistaAgregar.delegado = self
        } else if segue.identifier == "recetasPrevias" {
            //let vistaRP = segue.destination as! TableViewControllerRecetasPrevias
            
            
        } else if segue.identifier == "recetasFavoritas" {
            //print("PANPON")
            let vistaFavoritas = segue.destination as! TableViewControllerFavoritas
            vistaFavoritas.listaRecetasFavoritas = listaRecetasFavoritas
        }
        
    }
 */

    
}


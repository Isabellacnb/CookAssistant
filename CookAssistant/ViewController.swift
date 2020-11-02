//
//  ViewController.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 16/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocolAgregaReceta {
    

    @IBOutlet weak var tableViewRecipes: UITableView!
    @IBOutlet weak var tfIngrediente: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tableViewIngrediente: UITableView!
    @IBOutlet weak var stCantidad: UIStepper!
    @IBOutlet weak var addIngredient: UIButton!
    
    
    
    var listaIngredientes : [Ingrediente] = []
    var listaRecetas : [Receta] = []
    var listaRecetasFavoritas : [Receta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)         // Do any additional setup after loading the view.
        listaIngredientes = []
        self.navigationController!.navigationBar.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addRecipe" {

            print(listaRecetas)
            let vistaAgregar = segue.destination as! AddRecipeViewController
            vistaAgregar.delegado = self
        } else if segue.identifier == "recetasPrevias" {
            //let vistaRP = segue.destination as! TableViewControllerRecetasPrevias
            
            
        } else if segue.identifier == "recetasFavoritas" {
            print("PANPON")
            let vistaFavoritas = segue.destination as! TableViewControllerFavoritas
            vistaFavoritas.listaRecetasFavoritas = listaRecetasFavoritas
        }
        
    }


    func agregaReceta(rec: Receta) {
        listaRecetas.append(rec)
        //Reload table
    }
    
    func agregaFavorita(rec: Receta) {
        listaRecetasFavoritas.append(rec)
        print(listaRecetasFavoritas[0].nombre)
        print(listaRecetasFavoritas[0].esFav)
        print(listaRecetasFavoritas[0].pasos)
        print(listaRecetasFavoritas[0].ingredientes[0].nombre)
        print(listaRecetasFavoritas.count)
    }
    
}


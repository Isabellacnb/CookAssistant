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
    @IBOutlet weak var tableViewIngrediente: UITableView!
    @IBOutlet weak var addIngredient: UIButton!
    
    
    var listaIngredientes : [Ingrediente] = []
    var listaRecetas : [Receta] = []
    var listaRecetasFavoritas : [Receta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)         // Do any additional setup after loading the view.
        listaIngredientes = []

        }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func agregarIngrediente(_ sender: UIButton) {
        if (sender == addIngredient) {
            if let nom = tfIngrediente.text {
                let ingr = Ingrediente(nombre: nom)
                listaIngredientes.append(ingr)
                tableViewIngrediente.reloadData()
                tfIngrediente.text = ""
            }
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
            //let vistaFavoritas = segue.identifier as! TableViewControllerFavoritas
        }
        
    }


    func agregaReceta(rec: Receta) {
        listaRecetas.append(rec)
        //Reload table
    }
    
    func agregaFavorita(rec: Receta) {
        listaRecetasFavoritas.append(rec)
    }
    
}


//
//  ViewRecipeViewController.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 03/11/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class ViewRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var lbRecipeName: UILabel!
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var lbInstructions: UILabel!
    var listaIngredientes = [Ingrediente]()
    
    var unaReceta : Receta!
    
    @IBOutlet weak var tableViewIngrediente: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nombrar receta
        lbRecipeName.text = unaReceta.nombre
        
        // Guardar string de ingredientes en label
        tableViewIngrediente.delegate = self
        tableViewIngrediente.dataSource = self
        listaIngredientes = unaReceta.ingredientes
        
        // Guardar instrucciones de receta en label
        lbInstructions.text = unaReceta.pasos
        
        // Poner imagen a receta
        imgRecipe.image = unaReceta.imagen
        if unaReceta.esFav {
            btnStarFavorite.imageView?.image = UIImage(systemName: "star.fill")
        } else {
            unaReceta.esFav = true
            btnStarFavorite.imageView?.image = UIImage(systemName: "star")        }
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
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")!
        celda.textLabel?.text = listaIngredientes[indexPath.row].nombre
        celda.detailTextLabel?.text = String(listaIngredientes[indexPath.row].cantidad)
        
        return celda
    }
    
    //Se activa cuando le dan favorite, para quitar el favorite solamente le vuelven a picar
    @IBOutlet weak var btnStarFavorite: UIButton!
    @IBAction func favorite(_ sender: UIButton) {
        if unaReceta.esFav {
            unaReceta.esFav = false
            btnStarFavorite.imageView?.image = UIImage(systemName: "star")
        } else {
            unaReceta.esFav = true
            btnStarFavorite.imageView?.image = UIImage(systemName: "star.fill")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

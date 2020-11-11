//
//  ViewRecipeViewController.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 03/11/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

protocol protocolAgregaPrevia{
    func agregaPrevia(rec : Receta)
}

class ViewRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnBackRecipes: UIBarButtonItem!
    @IBOutlet weak var lbRecipeName: UILabel!
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var tfvInstructions: UITextView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    var esFav : Bool!
    var listaIngredientes = [Ingrediente]()
    var delegado : protocolAgregaPrevia!
    var edited = false
    var unaReceta : Receta!
    var canEdit = false
    var arrayMeasures : NSMutableArray = ["tsp", "tbsp", "oz", "cups", "pints", "quarts", "gal"]
    
    @IBOutlet weak var tableViewIngrediente: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Agregar logo al navigation bar
        let imageV = UIImageView(image: #imageLiteral(resourceName: "cookAssistantLogo"))
        imageV.frame = CGRect(x: 0, y: 0, width: 170, height: 42)
        imageV.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 42))
        titleView.addSubview(imageV)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
        
        // Nombrar receta
        lbRecipeName.text = unaReceta.nombre
        
        // Guardar string de ingredientes en label
        tableViewIngrediente.delegate = self
        tableViewIngrediente.dataSource = self
        listaIngredientes = unaReceta.ingredientes
        
        // Guardar instrucciones de receta en label
        tfvInstructions.text = unaReceta.pasos
        lbTime.text = unaReceta.tiempo + " Minutes"
        // Poner imagen a receta
        imgRecipe.image = unaReceta.imagen
        esFav = unaReceta.esFav
        if esFav {
            btnStarFavorite.imageView?.image = UIImage(systemName: "star.fill")
        } else {
            esFav = true
            btnStarFavorite.imageView?.image = UIImage(systemName: "star")
        }
        
        // Verificar si se esta viendo receta desde Favoritos o Recetas
        // Si viene de favoritas no se puede ver la opcion de editar
        if canEdit == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            self.navigationItem.leftBarButtonItem = nil
            
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
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")!
        celda.textLabel?.text = listaIngredientes[indexPath.row].nombre
        celda.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        let valorMedida = arrayMeasures[ listaIngredientes[indexPath.row].medida - 1]
        let strMedida = valorMedida as! String
        let detalle = String(listaIngredientes[indexPath.row].cantidad) + " " + strMedida
        celda.detailTextLabel?.text = detalle
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
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
    override func viewDidAppear(_ animated: Bool) {
        delegado.agregaPrevia(rec: unaReceta)
    }
 */
    
    @IBAction func unwindEditar(segue: UIStoryboardSegue) {
        lbRecipeName.text = unaReceta.nombre
        
        // Guardar string de ingredientes en label
        tableViewIngrediente.delegate = self
        tableViewIngrediente.dataSource = self
        listaIngredientes = unaReceta.ingredientes
        
        // Guardar instrucciones de receta en label
        tfvInstructions.text = unaReceta.pasos
        lbTime.text = unaReceta.tiempo
        // Poner imagen a receta
        imgRecipe.image = unaReceta.imagen
        if unaReceta.esFav {
            btnStarFavorite.imageView?.image = UIImage(systemName: "star.fill")
        } else {
            unaReceta.esFav = true
            btnStarFavorite.imageView?.image = UIImage(systemName: "star")
        }
        
        // Verificar si se esta viendo receta desde Favoritos o Recetas
        // Si viene de favoritas no se puede ver la opcion de editar
        if canEdit == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            
        }
        edited = true
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(edited)
        if segue.identifier == "editarReceta" {
            let editarR = segue.destination as! AddRecipeViewController
            editarR.nombre = lbRecipeName.text
            editarR.listaIngredientes = listaIngredientes
            editarR.isFav = unaReceta.esFav
            editarR.pasos = tfvInstructions.text
            editarR.tiempo = lbTime.text
            editarR.imagen = imgRecipe.image
            editarR.canEdit = true
        } else if segue.identifier == "unwindMod" {
            let modificarVista = segue.destination as! TableViewControllerRecetas
            let recetaNueva = Receta(nombre: lbRecipeName.text!, pasos: tfvInstructions.text!, esFav: esFav!, imagen: imgRecipe.image!, ingredientes: listaIngredientes, tiempo: lbTime.text!)
            modificarVista.recetaModificada = recetaNueva
        }

    }
    
    
    

}

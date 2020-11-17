//
//  ViewRecipeViewController.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 03/11/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit



class ViewRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnBackRecipes: UIBarButtonItem!
    @IBOutlet weak var lbRecipeName: UILabel!
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var tfvInstructions: UITextView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    @IBOutlet weak var imgFavStar: UIImageView!
    @IBOutlet weak var viewText: UIView!
    
    var time : String!
    var esFav : Bool!
    var listaIngredientes = [Ingrediente]()
    var listaRecetasPrevias = [Receta]()
    var edited = false
    var unaReceta : Receta!
    var canEdit = false
    var arrayMeasures : NSMutableArray = ["tsp", "tbsp", "cups", "gal", "units"]
    
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
        time = unaReceta.tiempo
        // Poner imagen a receta
        imgRecipe.image = unaReceta.imagen
        imgRecipe.contentMode = .scaleAspectFit
        esFav = unaReceta.esFav
        if esFav {
            imgFavStar.image = UIImage(systemName: "star.fill")
        } else {
            imgFavStar.image = UIImage(systemName: "star")
        }
        
        // Verificar si se esta viendo receta desde Favoritos o Recetas
        // Si viene de favoritas no se puede ver la opcion de editar
        if canEdit == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            self.navigationItem.leftBarButtonItem = nil
        }
        viewText.layer.borderWidth = 2
        viewText.layer.borderColor = UIColor.black.cgColor
        viewText.layer.cornerRadius = 4
        
    }
    
    // MARK: - Métodos de Table View Data Source INGREDIENTES
    //Carga la lista de ingredientes de la receta
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
        celda.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    //Se activa cuando le dan favorite, para quitar el favorite solamente le vuelven a picar

    //Una vez que se carga el view controller de una receta debe revisar si se agrega a recetas previas
    override func viewDidAppear(_ animated: Bool) {
        obtenerRecetasPrevias()
        var repetida = false
        //Recorre el arreglo para ver si la receta actual ya esta en el arreglo
        for recetaIndividual in listaRecetasPrevias {
            if (unaReceta.nombre == recetaIndividual.nombre){
                //Si se encuentra el valor de repetida es true
                repetida = true
            }
            
        }
        //Si no se repite se agrega a el arreglo de lista recetas previas
        if !repetida{
            listaRecetasPrevias.append(unaReceta)

            //Si el arreglo de recetas previas es más de 10 se elimina el valor más viejo
            if listaRecetasPrevias.count > 10 {
                listaRecetasPrevias.remove(at: 0)
            }
            //Guarda la lista actualizada
            guardarRecetas()
        }
    }
    
    //Obtiene el data path
    func dataFileURL(archivo : String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(archivo)
        return pathArchivo
    }
    
    //Carga el arreglo de recetas previas
    func obtenerRecetasPrevias() {
        // antes de cargar datos limpio el arreglo listaIngredientes
            listaRecetasPrevias.removeAll()
        
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "RecetasPrevias.plist"))
            listaRecetasPrevias = try PropertyListDecoder().decode([Receta].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de recetas")
        }
    }
    
    //Guardar las recetas previas
    @IBAction func guardarRecetas() {
        do {
            let dataRecetaPrevias = try PropertyListEncoder().encode(listaRecetasPrevias)
            try dataRecetaPrevias.write(to: dataFileURL(archivo: "RecetasPrevias.plist"))
        }
        catch {
            print("Error al guardar las recetas previas")
        }
    }
    @IBAction func unwindEditar(segue: UIStoryboardSegue) {
        lbRecipeName.text = unaReceta.nombre
        
        // Guardar string de ingredientes en label
        tableViewIngrediente.delegate = self
        tableViewIngrediente.dataSource = self
        listaIngredientes = unaReceta.ingredientes
        
        // Guardar instrucciones de receta en label
        tfvInstructions.text = unaReceta.pasos
        lbTime.text = unaReceta.tiempo + " Minutes"
        time = unaReceta.tiempo
        esFav = unaReceta.esFav
        // Poner imagen a receta
        imgRecipe.image = unaReceta.imagen
        if esFav {
            imgFavStar.image = UIImage(systemName: "star.fill")
        } else {
            imgFavStar.image = UIImage(systemName: "star")
        }
        tableViewIngrediente.reloadData()
        
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
            editarR.isFav = esFav
            editarR.pasos = tfvInstructions.text
            editarR.tiempo = time
            editarR.imagen = imgRecipe.image
            editarR.canEdit = true
        } else if segue.identifier == "unwindMod" {
            let modificarVista = segue.destination as! TableViewControllerRecetas
            let recetaNueva = Receta(nombre: lbRecipeName.text!, pasos: tfvInstructions.text!, esFav: esFav, imagen: imgRecipe.image!, ingredientes: listaIngredientes, tiempo: time!)
            modificarVista.recetaModificada = recetaNueva
        }

    }
    
    
    

}

//
//  TableViewControllerRecetas.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 03/11/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class TableViewControllerRecetas: UITableViewController, protocolAgregaReceta {
    
    let defaults = UserDefaults.standard
    var listaRecetas = [Receta]()
    var selectedRow : IndexPath = []
    var recetaModificada : Receta!
    var listaIngredientesDisp = [Ingrediente]()
    var listaRecetasDisp = [Receta]()
    
    @IBOutlet weak var filtro: UISegmentedControl!
    
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

        if FileManager.default.fileExists(atPath: dataFileURL(archivo: "Recetas.plist").path){
            obtenerRecetas()
        }
        if FileManager.default.fileExists(atPath: dataFileURL(archivo: "Ingredientes.plist").path) {
            obtenerIngredientes()
        }
        obtenerRecetasDisp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Cargar ingredientes en caso de tener nuevos para filtrar
        if FileManager.default.fileExists(atPath: dataFileURL(archivo: "Ingredientes.plist").path) {
            obtenerIngredientes()
        }
        
        obtenerRecetasDisp()
        
        if(filtro.selectedSegmentIndex == 1) {
            listaRecetasDisp = listaRecetas
        }
        
        tableView.reloadData()
    }
    
    // Funcion aux para checar si el ingrediente disponible es suficiente para el enecesario
    func ingredienteValido(_ necesario: Ingrediente, _ disponible:Ingrediente) -> Bool {
        if( necesario.nombre == disponible.nombre &&
            necesario.cantidad <= disponible.cantidad &&
            necesario.medida == disponible.medida) {
            return true
        }
        
        return false;
    }
    
    func obtenerRecetasDisp() {
        // Limpiar las recetas disponibles
        listaRecetasDisp.removeAll()
        
        // Agregar solo las listas que tengan ingredientes disponibles
        for k in (0..<listaRecetas.count) {
            var ingredientes = listaRecetas[k].ingredientes
            
            for i in (0..<ingredientes.count) {
                let ingre = ingredientes[i]
                for j in (0..<listaIngredientesDisp.count) {
                    if(ingredienteValido(ingre, listaIngredientesDisp[j])) {
                        ingredientes.remove(at: i)
                    }
                }
            }
            
            // Checar si la receta es unica (no tenemos otra con el mismo nombre)
            var repetida: Bool = false
            for receta in listaRecetasDisp {
                if(listaRecetas[k].nombre == receta.nombre) {
                    repetida = true
                }
            }
            
            // Si la lista de ingredientes esta vacia, se tiene todos los ingredientes para la receta k
            if(ingredientes.isEmpty && !repetida) {
                listaRecetasDisp.append(listaRecetas[k])
            }
        }
    }
    
    func obtenerIngredientes() {
        // antes de cargar datos limpio el arreglo listaIngredientes
        listaIngredientesDisp.removeAll()
        
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "Ingredientes.plist"))
            listaIngredientesDisp = try PropertyListDecoder().decode([Ingrediente].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de ingredientes")
        }
    }
    
    @IBAction func filtrarRecetas(_ sender: UISegmentedControl) {
        // Disponibles seleccionado
        if sender.selectedSegmentIndex == 0 {
            listaRecetasDisp.removeAll()
            obtenerRecetasDisp()
            tableView.reloadData()
        }
        // Todas seleccionado
        else {
            listaRecetasDisp.removeAll()
            obtenerRecetas()
            listaRecetasDisp = listaRecetas
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaRecetasDisp.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaRecetas", for: indexPath)
        
        cell.textLabel?.text = listaRecetasDisp[indexPath.row].nombre
        if (listaRecetasDisp[indexPath.row].esFav) {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .black, scale: .small)
            cell.imageView?.image = UIImage(systemName: "star.fill", withConfiguration: symbolConfig)
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let recetaBorrada = listaRecetasDisp[indexPath.row]
            for i in 0..<listaRecetas.count {
                let receta = listaRecetas[i]
                
                if(receta == recetaBorrada) {
                    listaRecetas.remove(at: i)
                    break
                }
            }
            listaRecetasDisp.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            guardarRecetas()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let tmp = listaRecetasDisp[fromIndexPath.row]
        listaRecetasDisp[fromIndexPath.row] = listaRecetasDisp[to.row]
        listaRecetasDisp[to.row] = tmp

    }
    

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecipe" {

            //print(listaRecetas)
            let vistaAgregar = segue.destination as! AddRecipeViewController
            vistaAgregar.delegado = self
        } else if segue.identifier == "viewRecipe" {
            let vistaVer = segue.destination as! ViewRecipeViewController
            let indice = tableView.indexPathForSelectedRow!
            vistaVer.unaReceta = listaRecetasDisp[indice.row]
            vistaVer.canEdit = true
            selectedRow = tableView.indexPathForSelectedRow!
        }
    }
    
    @IBAction func unwindModificar(segue: UIStoryboardSegue) {
        let recetaNueva = listaRecetasDisp[selectedRow.row]
        for i in 0..<listaRecetas.count {
            if(recetaNueva == listaRecetas[i]) {
                listaRecetas[i] = recetaModificada
            }
        }
        
        listaRecetasDisp[selectedRow.row] = recetaModificada
        guardarRecetas()
        tableView.reloadData()
    }
    
    // MARK: - Metodos del protocolo agrega categoria
    func agregaReceta(rec: Receta) {
        listaRecetas.append(rec)
        tableView.reloadData()
        guardarRecetas()
    }
    
    
    // MARK: - data file url ingredientes
    func dataFileURL(archivo : String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(archivo)
        print(pathArchivo)
        return pathArchivo
    }
    
    // MARK: - Métodos para guardar y obtener ingredientes
    @IBAction func guardarRecetas() {
        do {
            let dataReceta = try PropertyListEncoder().encode(listaRecetas)
            try dataReceta.write(to: dataFileURL(archivo: "Recetas.plist"))
        }
        catch {
            print("Error al guardar los ingredientes")
        }
    }
    
    func obtenerRecetas() {
        // antes de cargar datos limpio el arreglo listaIngredientes
            listaRecetas.removeAll()
        
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "Recetas.plist"))
            listaRecetas = try PropertyListDecoder().decode([Receta].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de recetas")
        }
        // despues de cargar los datos al arreglo listaempleados repinta el tableview
        tableView.reloadData()
    }
    
    
    func obtenerRecetasPrevias() {
        // antes de cargar datos limpio el arreglo listaIngredientes
            listaRecetas.removeAll()
        
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "RecetasPrevias.plist"))
            listaRecetas = try PropertyListDecoder().decode([Receta].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de recetas")
        }
    }
    
    
}

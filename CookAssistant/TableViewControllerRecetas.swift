//
//  TableViewControllerRecetas.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 03/11/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class TableViewControllerRecetas: UITableViewController, protocolAgregaReceta, protocolAgregaPrevia {
    
    let defaults = UserDefaults.standard
    var listaRecetas = [Receta]()
    var listaRecetasFavoritas : [Receta] = []
    var listaRecetasPrevias : [Receta] = []
    var selectedRow : IndexPath = []
    var recetaModificada : Receta!
    
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaRecetas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaRecetas", for: indexPath)

        cell.textLabel?.text = listaRecetas[indexPath.row].nombre
        if (listaRecetas[indexPath.row].esFav == true) {
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
            listaRecetas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            guardarRecetas()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let tmp = listaRecetas[fromIndexPath.row]
        listaRecetas[fromIndexPath.row] = listaRecetas[to.row]
        listaRecetas[to.row] = tmp

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
            vistaVer.delegado = self
            vistaVer.unaReceta = listaRecetas[indice.row]
            vistaVer.canEdit = true
            selectedRow = tableView.indexPathForSelectedRow!
        }
    }
    
    @IBAction func unwindModificar(segue: UIStoryboardSegue) {
        listaRecetas[selectedRow.row] = recetaModificada
        tableView.reloadData()
    }
    
    // MARK: - Metodos del protocolo agrega categoria
    func agregaReceta(rec: Receta) {
        listaRecetas.append(rec)
        tableView.reloadData()
        guardarRecetas()
    }
    
    func agregaFavorita(rec: Receta) {
        listaRecetasFavoritas.append(rec)
        guardarRecetas()
    }
    
    func agregaPrevia(rec: Receta) {
        print("HELLO WORLD")
        var repetida : Bool = false
        for recetaIndividual in listaRecetasPrevias {
            if (rec == recetaIndividual){
                repetida = false
            }
        }
        if !repetida{
            listaRecetasPrevias.append(rec)
            guardarRecetas()
        }
        if listaRecetasPrevias.count > 10 {
            listaRecetasPrevias.remove(at: 0)
        }
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
            let dataRecetaFavoritas = try PropertyListEncoder().encode(listaRecetasFavoritas)
            let dataRecetaPrevias = try PropertyListEncoder().encode(listaRecetasPrevias)
            try dataReceta.write(to: dataFileURL(archivo: "Recetas.plist"))
            try dataRecetaFavoritas.write(to: dataFileURL(archivo: "RecetasFavoritas.plist"))
            try dataRecetaPrevias.write(to: dataFileURL(archivo: "RecetasPrevias.plist"))
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
    }}

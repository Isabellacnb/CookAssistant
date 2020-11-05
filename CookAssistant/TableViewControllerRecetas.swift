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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recetas"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            cell.imageView?.image = UIImage(systemName: "star.fill")
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

        }
    }
    
    // MARK: - Metodos del protocolo agrega categoria
    func agregaReceta(rec: Receta) {
        listaRecetas.append(rec)
        tableView.reloadData()
    }
    
    func agregaFavorita(rec: Receta) {
        listaRecetasFavoritas.append(rec)
    }
    
    func agregaPrevia(rec: Receta) {
        listaRecetasPrevias.append(rec)
        if listaRecetasPrevias.count > 10 {
            listaRecetasPrevias.remove(at: 0)
        }
    }
    

}

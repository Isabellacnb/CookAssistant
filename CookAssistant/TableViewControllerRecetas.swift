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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "cookAssistantLogo")
        imageView.image = image
        navigationItem.titleView = imageView

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

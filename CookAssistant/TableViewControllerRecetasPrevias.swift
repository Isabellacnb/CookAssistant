//
//  TableViewControllerRecetasPrevias.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 19/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class customTableViewCell2: UITableViewCell{
    
    @IBOutlet weak var imgFotoReceta: UIImageView!
    @IBOutlet weak var lbNombreReceta: UILabel!
    @IBOutlet weak var lbTime: UILabel!
}

class TableViewControllerRecetasPrevias: UITableViewController {

    var listaRecetasPrevias : [Receta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recetas Previas"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaRecetasPrevias.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! customTableViewCell2

        cell.lbNombreReceta.text = listaRecetasPrevias[indexPath.row].nombre
        cell.imgFotoReceta.image = listaRecetasPrevias[indexPath.row].imagen
        cell.lbTime.text = listaRecetasPrevias[indexPath.row].tiempo

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRecipe" {
            let vistaVer = segue.destination as! ViewRecipeViewController
            let indice = tableView.indexPathForSelectedRow!
            vistaVer.unaReceta = listaRecetasPrevias[indice.row]
        }
    }

}

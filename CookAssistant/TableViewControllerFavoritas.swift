//
//  TableViewControllerFavoritas.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 19/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imgFotoReceta: UIImageView!
    @IBOutlet weak var lbNombreReceta: UILabel!
    @IBOutlet weak var lbTime: UILabel!
}


class TableViewControllerFavoritas: UITableViewController {

    var listaRecetasFavoritas = [Receta(nombre: "Cereal con leche", pasos: "Aqui van las instrucciones para servir el cereal y luego la leche en un bowl y asi poder desayunar", esFav: true, imagen: UIImage(named: "cereal")!, ingredientes: [Ingrediente(nombre: "Leche", cantidad: 1, medida: 3), Ingrediente(nombre: "Cereal", cantidad: 2, medida: 3)], tiempo: "120")]
    
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        if FileManager.default.fileExists(atPath: dataFileURL(archivo: "RecetasFavoritas.plist").path){
            obtenerRecetasFavoritas()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaRecetasFavoritas.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! customTableViewCell

        cell.lbNombreReceta.text = listaRecetasFavoritas[indexPath.row].nombre
        cell.imgFotoReceta.image = listaRecetasFavoritas[indexPath.row].imagen
        cell.lbTime.text = listaRecetasFavoritas[indexPath.row].tiempo + " min"

        return cell
    }
    
/*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 */
/*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listaRecetasFavoritas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let temp = listaRecetasFavoritas[fromIndexPath.row]
        listaRecetasFavoritas[fromIndexPath.row] = listaRecetasFavoritas[to.row]
        listaRecetasFavoritas[to.row] = temp
    }
 */
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRecipeFav" {
            let vistaVer = segue.destination as! ViewRecipeViewController
            let indice = tableView.indexPathForSelectedRow!
            vistaVer.unaReceta = listaRecetasFavoritas[indice.row]
            vistaVer.canEdit = false
        }
    }

    
    func dataFileURL(archivo : String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(archivo)
        print(pathArchivo)
        return pathArchivo
    }

    func obtenerRecetasFavoritas() {
        // antes de cargar datos limpio el arreglo listaIngredientes
            listaRecetasFavoritas.removeAll()
        
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "RecetasFavoritas.plist"))
            listaRecetasFavoritas = try PropertyListDecoder().decode([Receta].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de recetas")
        }
        tableView.reloadData();
    }
}

//
//  TableViewControllerFavoritas.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 19/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

//Crea una custom table view para cargar las recetas favoritas de una manera default
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
        
        //Si un archivo de RecetasPrevias existe se cargan los datos
        if FileManager.default.fileExists(atPath: dataFileURL(archivo: "Recetas.plist").path){
            obtenerRecetasFavoritas()
        }
    }

    //Una vez que se vuelva a cargar se cargan las recetas nuevamente
    override func viewWillAppear(_ animated: Bool) {
        obtenerRecetasFavoritas()
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
        cell.imgFotoReceta.contentMode = .scaleAspectFit
        cell.lbTime.text = listaRecetasFavoritas[indexPath.row].tiempo + " min"

        return cell
    }
    

    // MARK: - Navigation

    //Prepara los datos para enviarlos a el view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRecipeFav" {
            let vistaVer = segue.destination as! ViewRecipeViewController
            let indice = tableView.indexPathForSelectedRow!
            vistaVer.unaReceta = listaRecetasFavoritas[indice.row]
            vistaVer.canEdit = false
        }
    }

    //Carga el datapath
    func dataFileURL(archivo : String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(archivo)
        return pathArchivo
    }


    func obtenerRecetasFavoritas() {
        // antes de cargar datos limpio el arreglo recetas favoritas y carga el arreglo de recetas
            listaRecetasFavoritas.removeAll()
            var listaRecetas = [Receta]()
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "Recetas.plist"))
            listaRecetas = try PropertyListDecoder().decode([Receta].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de recetas")
        }
        
        //Recorre el arreglo recetas para encontrar las que son recetas favoritas y las carga
        for recetaIndividual in listaRecetas {
            if recetaIndividual.esFav {
                listaRecetasFavoritas.append(recetaIndividual)
            }
        }
        tableView.reloadData();
    }
}

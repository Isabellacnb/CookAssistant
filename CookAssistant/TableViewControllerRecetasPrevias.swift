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

    var listaRecetasPrevias = [Receta(nombre: "Cereal con leche", pasos: "Aqui van las instrucciones para servir el cereal y luego la leche en un bowl y asi poder desayunar", esFav: true, imagen: UIImage(named: "cereal")!, ingredientes: [Ingrediente(nombre: "Leche", cantidad: 1, medida: 3), Ingrediente(nombre: "Cereal", cantidad: 2, medida: 3)], tiempo: "120")]
    
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

        if FileManager.default.fileExists(atPath: dataFileURL(archivo: "RecetasPrevias.plist").path){
            obtenerRecetasPrevias()
        }
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
        cell.lbTime.text = listaRecetasPrevias[indexPath.row].tiempo + " min"

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRecipeRec" {
            let vistaVer = segue.destination as! ViewRecipeViewController
            let indice = tableView.indexPathForSelectedRow!
            vistaVer.unaReceta = listaRecetasPrevias[indice.row]
        }
    }

    func dataFileURL(archivo : String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(archivo)
        print(pathArchivo)
        return pathArchivo
    }

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
        tableView.reloadData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        obtenerRecetasPrevias()
    }
}

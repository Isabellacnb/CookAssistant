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
    var listaRectasPrevias = [Receta]()
    
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
    
    // Funcion que convierte todas las medidas a CUPS
    func universalValue(medida: Int, cantidad: Double) -> Double {
        // ["tsp", "tbsp", "cups", "gal", "units"]
        switch medida {
        // Tea spoon
        case 1:
            return cantidad / 48
        // Tablespoon
        case 2:
            return cantidad / 16
        // Cups
        case 3:
            return cantidad
        // Gal
        case 4:
            return cantidad * 16
        //Units
        case 5:
            return cantidad
        default:
            return -1
        }
    }
    
    // Funcion aux para checar si el ingrediente disponible es suficiente para el enecesario
    func ingredienteValido(_ necesario: Ingrediente, _ disponible:Ingrediente) -> Bool {
        // Ambos ingredientes tienen el mismo nombre
        if(necesario.nombre.caseInsensitiveCompare(disponible.nombre) == ComparisonResult.orderedSame) {
            // Controlar los ingredientes que son por unidad (units)
            if(necesario.medida == 5 && disponible.medida == 5 && necesario.cantidad <= disponible.cantidad) {
                return true
            } else if( (necesario.medida == 5 && disponible.medida != 5) ||
                        (necesario.medida != 5 && disponible.medida == 5)) {
                return false
            }
            
            // Se convierten las cantidades a cups y se evalua si hay suficientes
            if( universalValue(medida: necesario.medida, cantidad: necesario.cantidad) <= universalValue(medida: disponible.medida, cantidad: disponible.cantidad)) {
                return true
            }
        }
        return false;
    }
    
    // Funcion que mapea los ingredientes a un dicionario
    func mapIngreList(lista: [Ingrediente]) -> [String : Ingrediente] {
        var map: [String : Ingrediente] = [:]
        
        for i in (0..<lista.count) {
            map[lista[i].nombre.lowercased()] = lista[i]
        }
        
        return map
    }
    
    // Funcion que llena la lista de listaRecetasDisp con las recetas disponibles
    func obtenerRecetasDisp() {
        // Limpiar las recetas disponibles
        listaRecetasDisp.removeAll()
        let ingreDispMap = mapIngreList(lista: listaIngredientesDisp)
        
        // Agregar solo las listas que tengan ingredientes disponibles
        for k in (0..<listaRecetas.count) {
            let ingredientes = listaRecetas[k].ingredientes
            var ingreFound = 0
            
            for i in (0..<ingredientes.count) {
                let ingre = ingredientes[i]
                
                if(ingreDispMap[ingre.nombre.lowercased()] != nil && ingredienteValido(ingre, ingreDispMap[ingre.nombre.lowercased()]!)) {
                    ingreFound = ingreFound + 1
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
            if(ingredientes.count == ingreFound && !repetida) {
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
        } else {
            cell.imageView?.image = nil
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
            obtenerRecetasPrevias()
            var count = 0
            for recetaIndividual in listaRectasPrevias {
                if (recetaBorrada.nombre == recetaIndividual.nombre){
                    //Si se encuentra el valor de repetida es true
                    listaRectasPrevias.remove(at: count)
                    count += 1
                    guardarRecetasPrevias()
                }
            }
            
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
            listaRectasPrevias.removeAll()
        
        do {
            let data = try Data.init(contentsOf: dataFileURL(archivo: "RecetasPrevias.plist"))
            listaRectasPrevias = try PropertyListDecoder().decode([Receta].self, from: data)
        }
        catch {
            print("Error al cargar los datos del archivo de recetas")
        }
    }
    
    @IBAction func guardarRecetasPrevias() {
        do {
            let dataRecetaPrevias = try PropertyListEncoder().encode(listaRectasPrevias)
            try dataRecetaPrevias.write(to: dataFileURL(archivo: "RecetasPrevias.plist"))
        }
        catch {
            print("Error al guardar las recetas previas")
        }
    }
    
}

//
//  AddRecipeViewController.swift
//  CookAssistant
//
//  Created by user178773 on 10/17/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

protocol protocolAgregaReceta {
    func agregaReceta(rec : Receta)
    func agregaFavorita(rec : Receta)
}

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableViewIngrediente: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tfIngrediente : UITextField!
    @IBOutlet weak var tfTiempo: UITextField!
    @IBOutlet weak var stCantidad: UIStepper!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tvInstruciones: UITextView!
    @IBOutlet weak var imageLoaded: UIButton!
    @IBOutlet weak var btnSelectMeasure: UIButton!
    @IBOutlet weak var tableViewMeasures: UITableView!
    
    var arrayMeasures : NSMutableArray = ["tsp", "tbsp", "oz", "cups", "pints", "quarts", "gal"]
    
    var nombre : String!
    var listaIngredientes : [Ingrediente] = []
    var isFav : Bool = false
    var pasos : String!
    var imagen = UIImage(named: "defaultImg")
    var tiempo : String!
    var canEdit = false
    var idMeasure = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMeasures.delegate = self
        tableViewMeasures.dataSource = self
        // Agregar logo al navigation bar
        let imageV = UIImageView(image: #imageLiteral(resourceName: "cookAssistantLogo"))
        imageV.frame = CGRect(x: 0, y: 0, width: 170, height: 42)
        imageV.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 42))
        titleView.addSubview(imageV)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
        
        if (canEdit == true) {
            tfTiempo.text = tiempo
            tfNombre.text = nombre
            tvInstruciones.text = pasos
        }
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)         // Do any additional setup after loading the view.
        tfCantidad.text = "0"
        stCantidad.value = 0
        btnSave.layer.cornerRadius = 5
        btnSave.layer.borderWidth = 1
        btnSave.layer.borderColor = UIColor.black.cgColor
        btnSave.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        // Tableview measurements
        btnSelectMeasure.backgroundColor = UIColor.white
        btnSelectMeasure.layer.cornerRadius = 5
        btnSelectMeasure.layer.borderWidth = 1
        btnSelectMeasure.layer.borderColor = UIColor.black.cgColor
        btnSelectMeasure.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        tableViewMeasures.backgroundColor = UIColor.white
        tableViewMeasures.layer.cornerRadius = 5
        tableViewMeasures.layer.borderWidth = 1
        tableViewMeasures.layer.borderColor = UIColor.black.cgColor
        
        tableViewMeasures.isHidden = true
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    var delegado : protocolAgregaReceta!
    
    @IBAction func guardaReceta(_ sender: UIButton) {
        if tfNombre.text == "" || listaIngredientes.count == 0 || tiempo == "" || pasos == "" {
            let alerta = UIAlertController(title: "ERROR", message: "Complete all fields of information", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(accion)
            present(alerta, animated: true, completion: nil)
        } else if (canEdit == false) {
                let receta = Receta(nombre: tfNombre.text!, pasos: tvInstruciones.text!, esFav: isFav, imagen: imagen!, ingredientes: listaIngredientes, tiempo: tfTiempo.text!)
                if isFav {
                    delegado.agregaReceta(rec : receta)
                    delegado.agregaFavorita(rec: receta)
                    navigationController?.popViewController(animated: true)
                } else {
                    delegado.agregaReceta(rec : receta)
                    navigationController?.popViewController(animated: true)
                }
        }
       
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindEditar" {
            print("UnwindEditar")
            let vista = segue.destination as! ViewRecipeViewController
            let receta = Receta(nombre: tfNombre.text!, pasos: tvInstruciones.text!, esFav: isFav, imagen: imagen!, ingredientes: listaIngredientes, tiempo: tfTiempo.text!)
            vista.unaReceta = receta
            vista.edited = true
        }
    }
    
    
    // MARK: - Métodos de Table View Data Source INGREDIENTES
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableViewIngrediente) {
            return  listaIngredientes.count
        } else if (tableView == tableViewMeasures) {
            return arrayMeasures.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableViewIngrediente) {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda")!
            celda.textLabel?.text = listaIngredientes[indexPath.row].nombre
            celda.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            let valorMedida = arrayMeasures[ listaIngredientes[indexPath.row].medida - 1]
            let strMedida = valorMedida as! String
            let detalle = String(listaIngredientes[indexPath.row].cantidad) + " " + strMedida
            celda.detailTextLabel?.text = detalle
            
            return celda
        } else {
            let celda = tableView.dequeueReusableCell(withIdentifier: "cellM")
            celda?.textLabel?.text = (arrayMeasures[indexPath.row] as! String)
            return celda!
        }
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        if(tfIngrediente.text != "" && Int(tfCantidad.text!) != nil && Int(tfCantidad.text!)! > 0 && idMeasure > 0) {
            let ingr = Ingrediente(nombre: tfIngrediente.text!, cantidad: Int(tfCantidad.text!)!, medida: idMeasure)
            listaIngredientes.append(ingr)
            tableViewIngrediente.reloadData()
            
            // Limpiar textfields
            tfIngrediente.text = ""
            tfCantidad.text = "0"
            stCantidad.value = 0
            btnSelectMeasure.setTitle("----", for: UIControl.State.normal)
            btnSelectMeasure.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            let alerta = UIAlertController(title: "ERROR", message: "Complete all ingredient information to add new ingredient (name, quantity and measurement)", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(accion)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if(Int(tfCantidad.text!) != nil) {
            tfCantidad.text = String(Int(stCantidad.value))
        }
        
    }
    
    @IBAction func cambioManualCantidad(_ sender: Any) {
        if(Int(tfCantidad.text!) != nil) {
            stCantidad.value = Double(tfCantidad.text!)!
        }
        
    }
    

    //Se activa cuando le dan favorite, para quitar el favorite solamente le vuelven a picar
    @IBOutlet weak var favoriteStar: UIButton!
    @IBAction func favorite(_ sender: UIButton) {
        if isFav {
            isFav = false
            favoriteStar.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            isFav = true
            favoriteStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    //Image picker permite asignar una imagen a la receta
    @IBAction func addImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagen = foto
        imageLoaded.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Editing rows
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == tableViewIngrediente {
            if editingStyle == .delete {
                // Delete the row from the data source
                listaIngredientes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if tableView == tableViewIngrediente {
            let tmp = listaIngredientes[fromIndexPath.row]
            listaIngredientes[fromIndexPath.row] = listaIngredientes[to.row]
            listaIngredientes[to.row] = tmp
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Mostrar dropdown de measures
    @IBAction func btnSelectMeasure(_ sender: Any) {
        if tableViewMeasures.isHidden == true {
            tableViewMeasures.isHidden = false
        } else {
            tableViewMeasures.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
            if tableView == tableViewMeasures {
                let selectedItem = arrayMeasures[indexPath.row] as! String
                btnSelectMeasure.setTitle(selectedItem, for: UIControl.State.normal)
                if selectedItem == "tsp" {
                    idMeasure = 1
                } else if selectedItem == "tbsp"{
                    idMeasure = 2
                } else if selectedItem == "oz" {
                    idMeasure = 3
                } else if selectedItem == "cups" {
                    idMeasure = 4
                } else if selectedItem == "pints" {
                    idMeasure = 5
                } else if selectedItem == "quarts" {
                    idMeasure = 6
                } else if selectedItem == "gal" {
                    idMeasure = 7
                }
                tableViewMeasures?.isHidden = true

            }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewMeasures {
            return 20
        } else {
            return 55
        }
    }
    
    
}

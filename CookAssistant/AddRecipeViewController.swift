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
    
    // MARK: - Métodos de Table View Data Source INGREDIENTES
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableViewIngrediente) {
            return  listaIngredientes.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")!
        celda.textLabel?.text = listaIngredientes[indexPath.row].nombre
        celda.detailTextLabel?.text = String(listaIngredientes[indexPath.row].cantidad)
        
        return celda
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        if(tfIngrediente.text != "" && Int(tfCantidad.text!) != nil && Int(tfCantidad.text!)! > 0) {
            let ingr = Ingrediente(nombre: tfIngrediente.text!, cantidad: Int(tfCantidad.text!)!)
            listaIngredientes.append(ingr)
            tableViewIngrediente.reloadData()
            
            // Limpiar textfields
            tfIngrediente.text = ""
            tfCantidad.text = "0"
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
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var tfIngrediente : UITextField!
    @IBOutlet weak var stCantidad: UIStepper!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfInstruciones: UITextField!
    
    var nombre : String!
    var listaIngredientes : [Ingrediente] = []
    var isFav : Bool = false
    var pasos : String!
    var imagen = UIImage(named: "defaultImg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)         // Do any additional setup after loading the view.
        tfCantidad.text = "0"
        stCantidad.value = 0
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    var delegado : protocolAgregaReceta!
    
    @IBAction func guardaReceta(_ sender: UIButton) {
        let receta = Receta(nombre: tfNombre.text!, pasos: tfInstruciones.text!, esFav: isFav, imagen: imagen!, ingredientes: listaIngredientes)
        if isFav {
            delegado.agregaReceta(rec : receta)
            delegado.agregaFavorita(rec: receta)
            navigationController?.popViewController(animated: true)
        } else {
            delegado.agregaReceta(rec : receta)
            navigationController?.popViewController(animated: true)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

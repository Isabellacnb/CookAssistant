//
//  Ingrediente.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 16/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class Ingrediente: NSObject, Codable {
    //Declarar las variables
    var nombre : String
    var cantidad : Double
    var medida : Int
    
    //Inicializar las variables
    init (nombre : String, cantidad: Double, medida: Int) {
        self.nombre = nombre
        self.cantidad = cantidad
        self.medida = medida
    }

}

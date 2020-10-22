//
//  Ingrediente.swift
//  CookAssistant
//
//  Created by Isabella Canales Backhoff on 16/10/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class Ingrediente: NSObject {
    var nombre : String
    var cantidad : Int
        
    init (nombre : String, cantidad: Int) {
        self.nombre = nombre
        self.cantidad = cantidad
    }

}

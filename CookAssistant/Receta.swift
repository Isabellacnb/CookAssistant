//
//  Receta.swift
//  CookAssistant
//
//  Created by user178773 on 10/17/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class Receta: NSObject {
    var nombre : String
    var pasos : String
    var esFav : Bool
    var imagen : UIImage
    var ingredientes : [Ingrediente]
    
    init (nombre : String, pasos : String, esFav : Bool, imagen : UIImage, ingredientes : [Ingrediente]){
        self.nombre = nombre
        self.pasos = pasos
        self.esFav = false
        self.imagen = imagen
        self.ingredientes = ingredientes
    }
}

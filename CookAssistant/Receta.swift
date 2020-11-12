//
//  Receta.swift
//  CookAssistant
//
//  Created by user178773 on 10/17/20.
//  Copyright © 2020 Isabella Canales Backhoff. All rights reserved.
//

import UIKit

class Receta: NSObject, Codable {
    var nombre : String
    var pasos : String
    var esFav : Bool
    var imagen : UIImage?
    var ingredientes : [Ingrediente]
    var tiempo : String
    
    init (nombre : String, pasos : String, esFav : Bool, imagen : UIImage, ingredientes : [Ingrediente], tiempo : String){
        self.nombre = nombre
        self.pasos = pasos
        self.esFav = esFav
        self.imagen = imagen
        self.ingredientes = ingredientes
        self.tiempo = tiempo
    }
    
    enum CodingKeys: String, CodingKey{
        case nombre
        case pasos
        case esFav
        case imagen
        case ingredientes
        case tiempo
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nombre, forKey: .nombre)
        try container.encode(pasos, forKey: .pasos)
        try container.encode(esFav, forKey: .esFav)
        var dataDeFoto : Data?
        if let hayFoto = imagen {
            dataDeFoto = hayFoto.pngData()
        }
        else{
            dataDeFoto = nil
        }
        try container.encode(dataDeFoto, forKey: .imagen)
        try container.encode(ingredientes, forKey: .ingredientes)
        try container.encode(tiempo, forKey: .tiempo)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nombre = try container.decode(String.self, forKey: .nombre)
        pasos = try container.decode(String.self, forKey: .pasos)
        esFav = try container.decode(Bool.self, forKey: .esFav)
        let dataDeFoto = try container.decode(Data?.self, forKey: .imagen)
        if let hayFoto = dataDeFoto{
            imagen = UIImage(data: hayFoto)
        }
        else{
            imagen = nil
        }
        ingredientes = try container.decode([Ingrediente].self, forKey: .ingredientes)
        tiempo = try container.decode(String.self, forKey: .tiempo)
        
        
        
        
    }
}

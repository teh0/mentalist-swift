//
//  Periph.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation
import CoreBluetooth

class Periph {
    var name: String
    var instance: CBPeripheral
    var isConnected: Bool = false
    var isDiscovered: Bool = false
    
    init(name: String, instance: CBPeripheral) {
        self.name = name
        self.instance = instance
    }
    
    
}

//
//  PeriphManager.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation
import CoreBluetooth

/// In this exercice, this class is not really usefull because we could use BLEManager to interact with BLEServer. It was just in case
class PeriphManager {
    static var shared = PeriphManager()
    private var periphList: [Periph] = []
    private var selectedPeriph: Periph?
    
    /// Check is periph is registered
    func isPeriphRegistered(periphName: String) -> Bool {
        return (self.periphList.firstIndex(where: { (periph) -> Bool in
            periph.name == periphName
        }) != nil)
    }
    
    /// Return periph if registered
    func getPeriph(periphName: String) -> Periph? {
        var periph: Periph? = nil
        
        if let index = self.periphList.firstIndex(where: { (periph) -> Bool in
            return periph.name == periphName
        }) {
            periph = self.periphList[index]
        }
        
        return periph
    }
    
    /// Get periph list
    func getPeriphList() -> [Periph] {
        return self.periphList
    }
    
    /// Crea    te periph and registered in list
    func createPeriph(periphName: String, instance: CBPeripheral) -> Periph? {
        var periph: Periph? = nil
        if !self.isPeriphRegistered(periphName: periphName) {
            let newPerif = Periph(name: periphName, instance: instance)
            self.periphList.append(newPerif)
            periph = newPerif
        }
        
        return periph
    }
    
    /// Setter for selected periph
    func setSelectedPeriph(periph: Periph) {
        self.selectedPeriph = periph
    }
    
    /// Getter for selected periph
    func getSelectedPeriph() -> Periph? {
        return self.selectedPeriph
    }
}

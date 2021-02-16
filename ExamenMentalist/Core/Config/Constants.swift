//
//  Constants.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation
import CoreBluetooth

class Constants {
    
    static let SERVICE_UUID = CBUUID(string: "A14318C7-62FF-484F-81B9-7A4681F47600")
    static let READ_CHARACTERISTIC_UUID = CBUUID(string: "B2DBA4DB-6C7B-4649-A66D-2308B7BB835F")
    static let WRITE_CHARACTERISTIC_UUID = CBUUID(string: "39558C62-0EF9-472F-8E38-01F70A07AC55")
    static let CITY_CHARACTERISTIC_UUID = CBUUID(string: "9DE0451B-4F87-4677-9FC4-2C81BDF27822")
    static let BLE_SERVER_NAME = "theo"
}

//
//  BLEManager.swift
//  BLEClient
//
//  Created by Sébastien Hernoux on 27/02/2020.
//  Copyright © 2020 Sébastien Hernoux. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject {
    static let instance = BLEManager()
    
    private var historicMessage: [BLEMessage] = []
    var isBLEEnabled = false
    var isScanning = false
    var centralManager: CBCentralManager?
    var connectedPeripherals = [CBPeripheral]()
    var readyPeripherals = [CBPeripheral]()
    var scanCallback: ((CBPeripheral, String) -> ())?
    var connectCallback: ((CBPeripheral) -> ())?
    var disconnectCallback: ((CBPeripheral) -> ())?
    var didFinishDiscoveryCallback: ((CBPeripheral) -> ())?
    var globalDisconnectCallback: ((CBPeripheral) -> ())?
    var sendDataCallback: ((String?) -> ())?
    var messageReceivedCallback:((Data?)->())?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func clear() {
        connectedPeripherals = []
        readyPeripherals = []
    }
    
    /// Scan all BLE periphs
    func scan(callback: @escaping (CBPeripheral, String) -> ()) {
        isScanning = true
        scanCallback = callback
        centralManager?.scanForPeripherals(withServices: [], options: nil)
    }
    
    /// Stop scan
    func stopScan() {
        isScanning = false
        centralManager?.stopScan()
    }
    
    /// Connect to a periph
    func connectPeripheral(_ periph: CBPeripheral, callback: @escaping (CBPeripheral) -> ()) {
        connectCallback = callback
        centralManager?.connect(periph, options: nil)
    }
    
    /// Discover a periph
    func discoverPeripheral(_ periph: CBPeripheral, callback: @escaping (CBPeripheral) -> ()) {
        didFinishDiscoveryCallback = callback
        periph.delegate = self
        periph.discoverServices(nil)
        
    }
    
    /// Disconnect to a periph
    func disconnectPeripheral(_ periph: CBPeripheral, callback: @escaping (CBPeripheral) -> ()) {
        disconnectCallback = callback
        centralManager?.cancelPeripheralConnection(periph)
    }
    
    func didDisconnectPeripheral(callback: @escaping (CBPeripheral) -> ()) {
        disconnectCallback = callback
        globalDisconnectCallback = callback
    }
    
    /// Get CBCharacteristic object from CBUUID
    func getCharForUUID(_ uuid: CBUUID, forperipheral peripheral: CBPeripheral) -> CBCharacteristic? {
        if let services = peripheral.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for char in characteristics {
                        if char.uuid == uuid {
                            return char
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /// Send data to a spceific characteristic
    func sendData(characId: CBUUID, data: Data, callback: @escaping (String?) -> ()) {
        sendDataCallback = callback
        for periph in readyPeripherals {
            if let char = BLEManager.instance.getCharForUUID(characId, forperipheral: periph) {
                periph.writeValue(data, for: char, type: CBCharacteristicWriteType.withResponse)
                self.historicMessage.append(BLEMessage.init(text: data, messageType: .WRITTEN))
            }
        }
    }
    
    /// Listen BLE messages
    func listenForMessages(characId: CBUUID, callback:@escaping(Data?)->()) {
        messageReceivedCallback = callback
        
        for periph in readyPeripherals {
            if let char = BLEManager.instance.getCharForUUID(characId, forperipheral: periph) {
                periph.readValue(for: char)
            }
        }
    }
    
    /// Get all historic messages
    func getHistoricMessage() -> [BLEMessage] {
        return self.historicMessage
    }
    
    /// Add new  message to the historic
    func addHistoricMessage(message: BLEMessage) {
        self.historicMessage.append(message)
    }
    
}

// MARK: - CBPeripheralDelegate extensions
extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let services = peripheral.services {
            let count = services.filter { $0.characteristics == nil }.count
            if count == 0 {
                for s in services {
                    for c in s.characteristics! {
                            peripheral.setNotifyValue(true, for: c)
                    }
                }
                readyPeripherals.append(peripheral)
                didFinishDiscoveryCallback?(peripheral)
            }
        }
    }
}

// MARK: - CBCentralManagerDelegate extensions
extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBLEEnabled = true
        } else {
            isBLEEnabled = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        if let name = localName {
            scanCallback?(peripheral, name)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if !connectedPeripherals.contains(peripheral) {
            connectedPeripherals.append(peripheral)
            connectCallback?(peripheral)
        }
    }
        
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripherals.removeAll { $0 == peripheral }
        readyPeripherals.removeAll { $0 == peripheral }
        disconnectCallback?(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        messageReceivedCallback?(characteristic.value)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        sendDataCallback?(peripheral.name)
    }
}



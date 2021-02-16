//
//  BLEMessage.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation

struct BLEMessage {
    var text: Data
    var messageType: BLEMessageType
    
    func getHistoricRender() -> String {
        return "\(self.messageType.rawValue) : \(String(decoding: self.text, as: UTF8.self))"
    }
    
    func getTextAsString() -> String {
        return String(decoding: self.text, as: UTF8.self)
    }
}

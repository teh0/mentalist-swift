//
//  BaseStep.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation

class BaseStep: ExerciceStep {
    private(set) weak var context: ExercicesHandler?

    /// OVERRIDE NEEDED !
    func handleExercice(inputData: Data) {
        
    }
    
    func setContext(context: ExercicesHandler) {
        self.context = context
    }
    
    func getStringFromBinary(binary: Data) -> String {
        return String(decoding: binary, as: UTF8.self)
    }
    
    func activeNextStep(step: ExerciceStep) -> Void {
        self.context?.setStep(step: step)
    }
    
    func sendData(data: String) -> Void {
        BLEManager.instance.sendData(characId: Constants.WRITE_CHARACTERISTIC_UUID, data: data.data(using: .utf8)!) { (data) in
        }
    }
}

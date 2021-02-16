//
//  StepOne.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation

class StepOne: BaseStep {
    override func handleExercice(inputData: Data) {
        print("Step one called")
        let textData = self.getStringFromBinary(binary: inputData)
        
        let splitedData = textData.components(separatedBy: ":")
        print(splitedData)
        
        for letter in splitedData {
            self.sendData(data: letter)
        }
    
        self.activeNextStep(step: StepTwo())
    }
}

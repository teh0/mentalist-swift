//
//  StepTwo.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation

class StepTwo: BaseStep {
    override func handleExercice(inputData: Data) {
        print("Step two called")
        let textData = self.getStringFromBinary(binary: inputData)
        let splitedData = Array(textData.components(separatedBy: ":").reversed())
        print(splitedData)
        for letter in splitedData {
            self.sendData(data: letter)
        }
        
        self.activeNextStep(step: StepThree())
    }
}

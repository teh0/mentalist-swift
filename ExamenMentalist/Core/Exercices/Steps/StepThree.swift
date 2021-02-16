//
//  StepThree.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation
import StringMetric

class StepThree: BaseStep {
    private var stringData: String?
    private var answerList: [String] = ["content", "pas content", "pourquoi j'ai choisi DMII?"]
    
    override func handleExercice(inputData: Data) {
        if stringData == nil {
            self.stringData = self.getStringFromBinary(binary: inputData)
        } else {
            let textToCompare = self.getStringFromBinary(binary: inputData)
            self.sendData(data: self.getClosestWord(textToCompare: textToCompare))
            self.activeNextStep(step: StepFour())
        }
    }
    
    private func getClosestWord(textToCompare: String) -> String {
        var minDistance = 1.0
        let words = self.stringData!.components(separatedBy: ":")
        var answser = self.answerList.first!
        
        for (index, word) in words.enumerated() {
            let distance = word.distanceJaroWinkler(between: textToCompare)
            print("Distance of word \(word) -> \(distance)")
            if distance < minDistance {
                answser = self.answerList[index]
                minDistance = distance
            }
        }
        
        print("Return value : \(answser)")
        return answser
    }
}

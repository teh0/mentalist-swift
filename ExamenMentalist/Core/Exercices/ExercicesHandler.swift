//
//  ExercicesHandler.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation

/// This class is in charge of resolve each mini exercices.
class ExercicesHandler {
    
    /// Design pattern State : https://refactoring.guru/design-patterns/state
    private var step: ExerciceStep
    
    init(step: ExerciceStep) {
        self.step = step
        self.setStep(step: step)
    }
    
    /// Set the current exercice step which will be called for exercice resolution when read button is pressed
    public func setStep(step: ExerciceStep) {
        self.step = step
        self.step.setContext(context: self)
    }
    
    /// This method will call `handleExercice` method of current step
    public func handle(dataExercice: Data) {
        self.step.handleExercice(inputData: dataExercice)
    }
}

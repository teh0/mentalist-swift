//
//  ExerciceStep.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import Foundation

protocol ExerciceStep {
    func handleExercice(inputData: Data) -> Void
    func setContext(context: ExercicesHandler) -> Void
}

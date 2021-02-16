# Mentalist
La partie fonctionnelle du projet se situe dans le dossier `Core`

# Dossier Core
``` 
.
├── BLE
│   ├── BLEManager.swift
│   ├── Messages
│   │   ├── BLEMessage.swift
│   │   └── BLEMessageType.swift
│   └── Periph
│       ├── Periph.swift
│       └── PeriphManager.swift
├── Config
│   └── Constants.swift
└── Exercices
    ├── ExercicesHandler.swift
    └── Steps
        ├── BaseStep.swift
        ├── ExerciceStep.swift
        ├── StepFour.swift
        ├── StepOne.swift
        ├── StepThree.swift
        └── StepTwo.swift
```

### Dossier BLE
Il comporte toute la logique de la communication BLE avec le serveur
* **BLEManager** : Reprends le manager fournis mais on rajoute certaines méthodes pour gérer l'historique, l'envoi et la reception des données
* **Messages** : Model qui représente le message
* **Periph** : Gère les instances des périphériques BLE (pas très utiles dans ce cas)

### Dossier Config
* **Constants** : Stock toutes les constants de l'appli (UIID des charac ...).

### Exercices
* **ExerciceHandler** : Classe qui gère toute la logique de la résolution des petits exos.
Utilisation du design pattern [state](https://refactoring.guru/design-patterns/state) pour créer une interface simple d'utilisation dans le controller :
  ```swift
   self.exercicesHandler.handle(dataExercice: message.text)
  ```
  `message.text` étant les données récupérées dans le read.
  
  Voici un petit aperçu de ce qui se passe en interne :
  ```swift 
      /// This method will call `handleExercice` method of current step
    public func handle(dataExercice: Data) {
        self.step.handleExercice(inputData: dataExercice)
    }
  ```
  On déporte la logique de la résolution de l'exercice à l'instance de la step en cours. Pour passer d'une step à l'autre
  on a juste à injecter l'instance de la prochaine step directement dans les classes Steps : 
  
  Exemple avec la classe `Step1.swift` : 

  ```swift
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
  ```
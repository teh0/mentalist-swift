//
//  CommunicationTabViewController.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import UIKit

class CommunicationTabViewController: UIViewController {
    
    private var receivedMessage: [BLEMessage] = []
    private var exercicesHandler = ExercicesHandler(step: StepOne())

    // MARK: - UI PROPERTIES
    @IBOutlet weak var communicationTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var readMessageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initController()
        initMessageReadTableView()
        hideKeyboardWhenTappedAround()
    }
    
    private func initController() {
        self.title = "Communication"
        self.communicationTextField.placeholder = PeriphManager.shared.getSelectedPeriph()?.name
    }
    
    private func initMessageReadTableView() {
        self.readMessageTableView.delegate = self
        self.readMessageTableView.dataSource = self
    }
    
    
    // MARK: - UI EVENTS
    @IBAction func onClickSendButton(_ sender: UIButton) {
        if let text = self.communicationTextField.text {
            print("Input value : \(text)")
            BLEManager.instance.sendData(characId: Constants.WRITE_CHARACTERISTIC_UUID, data: text.data(using: .utf8)!) { (data) in
                
            }
        }
    }
    
    @IBAction func onClickReadButton(_ sender: UIButton) {
        BLEManager.instance.listenForMessages(characId: Constants.READ_CHARACTERISTIC_UUID) { (data) in
            if let binary = data {
                let message = BLEMessage.init(text: binary, messageType: .READ)
                self.receivedMessage.append(message)
                BLEManager.instance.addHistoricMessage(message: message)
                self.readMessageTableView.reloadData()
                self.exercicesHandler.handle(dataExercice: message.text)
            }
        }
    }
}

extension CommunicationTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receivedMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.readMessageTableView.dequeueReusableCell(withIdentifier: "readMessageCell", for: indexPath)
        let message = self.receivedMessage[indexPath.row]
        cell.textLabel?.text = message.getTextAsString()
        
        return cell
    }
    
    
}

extension CommunicationTabViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CommunicationTabViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

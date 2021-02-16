//
//  HistoricTabViewController.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import UIKit

class HistoricTabViewController: UIViewController {

    @IBOutlet weak var historicTableView: UITableView!
    
    override func viewDidLoad() {
        print(BLEManager.instance.getHistoricMessage())
        super.viewDidLoad()
        self.title = "Historic"
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.historicTableView.reloadData()
    }
    
    private func initTableView() {
        self.historicTableView.dataSource = self
        self.historicTableView.delegate = self
    }
}

extension HistoricTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEManager.instance.getHistoricMessage().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historicTableView.dequeueReusableCell(withIdentifier: "historicCell", for: indexPath)
        let historic = BLEManager.instance.getHistoricMessage()
        cell.textLabel?.text = historic[indexPath.row].getHistoricRender()
        
        return cell
    }
    
    
}

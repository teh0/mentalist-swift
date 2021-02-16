//
//  ScanViewController.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import UIKit

class ScanViewController: UIViewController {

    // MARK: - UI PROPERTIES
    @IBOutlet weak var scanTableView: UITableView!
    @IBOutlet weak var listAllButton: UIButton!
    
    // MARK: - DATA PROPERTIES
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    /// Init scan table view
    private func initTableView() {
        self.scanTableView.delegate = self
        self.scanTableView.dataSource = self
    }
    
    // MARK: - BLE Logic
    private func scanPeriphs() {
        BLEManager.instance.scan { (periph, periphName) in
            if !PeriphManager.shared.isPeriphRegistered(periphName: periphName) {
                if PeriphManager.shared.createPeriph(periphName: periphName, instance: periph) != nil {
                    self.scanTableView.reloadData()
                }
            }
        }
    }
    
    private func connectPeriph(periph: Periph) {
        BLEManager.instance.connectPeripheral(periph.instance) { (periphInstance) in
            periph.isConnected = true
            BLEManager.instance.discoverPeripheral(periphInstance) { (periphInstance) in
                periph.isDiscovered = true
            }
        }
    }
    
    // MARK: - UI Events
    @IBAction func onClickListAllButton(_ sender: UIButton) {
        print("onClickListAllButton")
        scanPeriphs()
    }
    
}

extension ScanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PeriphManager.shared.getPeriphList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.scanTableView.dequeueReusableCell(withIdentifier: "scanCell", for: indexPath)
        let periph = PeriphManager.shared.getPeriphList()[indexPath.row]
        cell.textLabel?.text = periph.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEManager.instance.stopScan()
        let selectedPeriph = PeriphManager.shared.getPeriphList()[indexPath.row]
        self.connectPeriph(periph: selectedPeriph)
        PeriphManager.shared.setSelectedPeriph(periph: selectedPeriph)
        self.performSegue(withIdentifier: "toPeriphView", sender: self)
    }
    
    
}

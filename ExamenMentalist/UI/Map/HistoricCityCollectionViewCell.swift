//
//  HistoricCityCollectionViewCell.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import UIKit

class HistoricCityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(cityName: String) {
        self.cityNameLabel.text = cityName
    }
}

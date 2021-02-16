//
//  MapTabViewController.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import UIKit
import CoreLocation
import MapKit

class MapTabViewController: UIViewController {
    
    private var cityHistoric: [String] = ["Yolo"]

    @IBOutlet weak var lectureButton: UIButton!
    @IBOutlet weak var cityHistoricCollectionView: UICollectionView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        self.initCollectionView()
    }
    
    @IBAction func onClickLectureButton(_ sender: UIButton) {
        print("onClickLectureButton")
        self.updateMapPosition()
    }
    
    func initCollectionView() {
        self.cityHistoricCollectionView.delegate = self
        self.cityHistoricCollectionView.dataSource = self
    }
    
    func updateMapPosition() {
        BLEManager.instance.listenForMessages(characId: Constants.CITY_CHARACTERISTIC_UUID) { (data) in
            if let cityBinary = data {
                let city = String(decoding: cityBinary, as: UTF8.self)
                print("city")
                self.cityHistoric.append(city)
                print(self.cityHistoric)
                self.cityHistoricCollectionView.reloadData()
                BLEManager.instance.addHistoricMessage(message: BLEMessage.init(text: cityBinary, messageType: .READ))
                
                self.getGeolocationFromCityName(forPlaceCalled: city) { (location) in
                    if let location = location {
                        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        print("Region : \(region)")
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            }
        }
    }
        
    func getGeolocationFromCityName(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(name) { placemarks, error in
                
                guard error == nil else {
                    print("*** Error in \(#function): \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let placemark = placemarks?[0] else {
                    print("*** Error in \(#function): placemark is nil")
                    completion(nil)
                    return
                }
                
                guard let location = placemark.location else {
                    print("*** Error in \(#function): placemark is nil")
                    completion(nil)
                    return
                }

                completion(location)
            }
        }
}

extension MapTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView numberOfItemsInSection")
        return self.cityHistoric.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView cellForItemAt")
        let historicCell = self.cityHistoricCollectionView.dequeueReusableCell(withReuseIdentifier: "historicCityCell", for: indexPath) as! HistoricCityCollectionViewCell
        print(self.cityHistoric[indexPath.row])
        historicCell.configure(cityName: self.cityHistoric[indexPath.row])
        
        return historicCell
    }
    
    
}

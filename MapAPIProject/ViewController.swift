//
//  ViewController.swift
//  MapAPIProject
//
//  Created by 박다혜 on 2023/08/27.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit


class ViewController: UIViewController {

    let mapView = MKMapView()
    let searchBar = UISearchBar()

    let locationButton = LocationButton(frame: .zero)

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapGestureRecognizer)

        setLayout()
        setConfiguration()
    }


}

extension ViewController: CLLocationManagerDelegate {

}

extension ViewController {

    func setLayout() {

        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }

        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.size.equalTo(view.snp.width).multipliedBy(0.15)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }

    func setConfiguration() {

        searchBar.searchTextField.addTarget(self, action: #selector(searchButtonDidTap), for: .editingDidEndOnExit)

    }

    @objc func searchButtonDidTap() {
        searchBar.endEditing(true)
    }

    @objc func viewDidTap() {
        searchBar.endEditing(true)
    }


}

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
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.51845, longitude: 126.88494)
    var currentLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapGestureRecognizer)

        setLayout()
        setConfiguration()

        checkDeviceLocationAuth()
    }

    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }


}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cordinate = locations.last?.coordinate {
            setRegion(center: cordinate)
            currentLocation = cordinate
        }

        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        setRegion(center: defaultLocation)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuth()
    }

}

extension ViewController {

    func checkDeviceLocationAuth() {

        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let auth: CLAuthorizationStatus

                if #available(iOS 14.0, *) {
                    auth = self.locationManager.authorizationStatus
                } else {
                    auth = CLLocationManager.authorizationStatus()
                }

                DispatchQueue.main.async {
                    self.checkAppLocationAuth(status: auth)
                }
            } else {
                self.showRequestLocationServiceAlert()
            }
        }
    }

    func checkAppLocationAuth(status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("")
        case .denied:
            showRequestLocationServiceAlert()
        case .authorizedAlways:
            print("")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorized:
            print("")
        @unknown default:
            print("")
        }
    }

    func showRequestLocationServiceAlert() {

      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)

        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
      }

      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)

      present(requestLocationServiceAlert, animated: true, completion: nil)

    }

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

        locationManager.delegate = self
        searchBar.searchTextField.addTarget(self, action: #selector(searchButtonDidTap), for: .editingDidEndOnExit)
        locationButton.addTarget(self, action: #selector(locationButtonDidTap), for: .touchUpInside)
        mapView.showsUserLocation = true

    }

    @objc func locationButtonDidTap() {
        if let currentLocation = self.currentLocation {
            setRegion(center: currentLocation)
        } else {
            setRegion(center: defaultLocation)
        }
    }

    @objc func searchButtonDidTap() {
        searchBar.endEditing(true)
    }

    @objc func viewDidTap() {
        searchBar.endEditing(true)
    }


}

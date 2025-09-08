//
//  LocationService.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/07.
//

// CHANGED: このファイルは、デッドロックの原因を特定するために各メソッドにprint文を追加しています
import Foundation
import CoreLocation
import RxSwift

enum LocationError: Error {
    case permissionDenied
    case unknown
}

final class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    private let locationManager = CLLocationManager()
    
    var currentLocation: Observable<CLLocationCoordinate2D> {
        return locationSubject.asObservable()
    }
    private let locationSubject = PublishSubject<CLLocationCoordinate2D>()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        print("✅ LocationService: Initialized")
    }
    
    func requestLocation() {
        print("➡️ LocationService: requestLocation() called. Auth status: \(locationManager.authorizationStatus.rawValue)")
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationSubject.onError(LocationError.permissionDenied)
        @unknown default:
            locationSubject.onError(LocationError.unknown)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("✅ LocationService: didUpdateLocations with \(locations.count) location(s)")
        guard let location = locations.first else { return }
        locationSubject.onNext(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🚨 LocationService: didFailWithError: \(error.localizedDescription)")
        locationSubject.onError(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("🔄 LocationService: locationManagerDidChangeAuthorization. New status: \(manager.authorizationStatus.rawValue)")
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
}

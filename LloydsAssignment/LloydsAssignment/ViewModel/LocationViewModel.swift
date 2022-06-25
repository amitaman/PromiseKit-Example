//
//  LocationViewModel.swift
//  LloydsAssignment
//
//  Created by Amit Aman on 22/05/22.
//

import Foundation
import CoreLocation
import PromiseKit
import Contacts

protocol LocationDataDelegate: AnyObject {
    func didReceivedLocationData(placeMark: CLPlacemark)
    func didFailedLocationDataWith(error: NSError)
    
}
class LocationViewModel {
    
    // MARK: - Properties
    let coder = CLGeocoder()
    weak var locationDelegate: LocationDataDelegate?
    
    // MARK: - init.
    init() {
        self.getLocationData()
        
    }
    
    
    // MARK: - Get Location Data.
    func getLocationData() {
        self.getLocationPlacemark()
            .done { [weak self] placemark in
                self?.locationDelegate?.didReceivedLocationData(placeMark: placemark)
            }
            .catch { [weak self] error in
                guard let self = self else { return }
                switch error {
                case is CLError where (error as? CLError)?.code == .denied:
                    let customError = NSError(domain: "", code: 4001,
                                              userInfo: [ NSLocalizedDescriptionKey: Constants.enable_location_permissions_error])
                    self.locationDelegate?.didFailedLocationDataWith(error: customError)
                default:
                    self.locationDelegate?.didFailedLocationDataWith(error: error as NSError)
                    break
                }
            }
    }
    
    // MARK: - Get Location Placemark.
    func getLocationPlacemark() -> Promise<CLPlacemark> {
        return CLLocationManager.requestLocation().lastValue
            .then { location in
                return self.coder.reverseGeocode(location: location).firstValue
            }
    }
    
    // MARK: - Search for Placemark.
    func searchForPlacemark(text: String) -> Promise<CLPlacemark> {
        let postalAddr = CNMutablePostalAddress()
        postalAddr.city = String(format: "%@", text)
        return coder.geocodePostalAddress(postalAddr).firstValue
    }

}


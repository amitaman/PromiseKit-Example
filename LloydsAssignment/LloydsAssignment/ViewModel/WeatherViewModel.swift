//
//  WeatherViewModel.swift
//  LloydsAssignment
//
//  Created by Amit Aman on 22/05/22.
//

import Foundation
import UIKit
import PromiseKit

protocol WeatherInfoDelegate: AnyObject {
    func didReceivedWeatherInfo(weatherInfo: WeatherInfo)
    func didFailedWeatherInfoWith(error: NSError)
    func didCallDonePromise(icon: UIImage)
    
}
class WeatherViewModel {
    
    // MARK: - Properties
    weak var weatherInfoDelegate: WeatherInfoDelegate?
    let locationViewModel = LocationViewModel()
    
    //MARK: - init()
    init() {
        locationViewModel.locationDelegate = self
    }
    
    // MARK: - Methods
    
    func getWeatherInfo(coordinate: CLLocationCoordinate2D ) {
        getWeather(atLatitude: coordinate.latitude,
                   longitude: coordinate.longitude)
        .then { [weak self] weatherInfo -> Promise<UIImage> in
            guard let self = self else { return brokenPromise() }
            self.weatherInfoDelegate?.didReceivedWeatherInfo(weatherInfo: weatherInfo)
            return self.getIcon(named: weatherInfo.weather.first!.icon)
        }
        .done(on: DispatchQueue.main) { icon in
            self.weatherInfoDelegate?.didCallDonePromise(icon: icon)
        }
        .catch {[weak self] error in
            self?.weatherInfoDelegate?.didFailedWeatherInfoWith(error: error as NSError)
        }
    }
    
    
    func getWeather(atLatitude latitude: Double, longitude: Double) -> Promise<WeatherInfo> {
        return firstly {
            APIServiceManager().getWeatherData(with: latitude, long: longitude, nameSpacer: .promise)
        }.map {
            return try JSONDecoder().decode(WeatherInfo.self, from: $0.data)
        }
    }
    
    /// Get Icon for weather.
    /// - Parameter iconName: String
    /// - Returns: Promise<UIImage>
    func getIcon(named iconName: String) -> Promise<UIImage> {
        return Promise<UIImage> {
            FileManagerUtil().getFile(named: iconName, completion: $0.resolve)
        }
        .recover { _ in
            self.getIconFromNetwork(named: iconName)
        }
    }
    
    /// Get Icon From Network.
    /// - Parameter iconName: String
    /// - Returns: Promise<UIImage>
    func getIconFromNetwork(named iconName: String) -> Promise<UIImage> {
        return firstly {
            APIServiceManager().getIconName(with: iconName, nameSpacer: .promise)
        }
        .then(on: DispatchQueue.global(qos: .background)) { urlResponse in
            return Promise {
                FileManagerUtil().saveFile(named: iconName, data: urlResponse.data, completion: $0.resolve)
            }
            .then(on: DispatchQueue.global(qos: .background)) {
                return Promise.value(UIImage(data: urlResponse.data) ?? UIImage())
            }
        }
    }
    
    /// Convert number to Temperature formate.
    /// - Parameter weatherInfo: WeatherInfo modle.
    /// - Returns: String optional
    func convertTemperatureFormate(weatherInfo: WeatherInfo) -> String? {
        let mf = MeasurementFormatter()
        let tempMeasurement = Measurement(value: weatherInfo.main.temp, unit: UnitTemperature.kelvin)
        let numberFormatter = NumberFormatter()
        mf.locale = .current
        numberFormatter.numberStyle = .none
        mf.numberFormatter = numberFormatter
        return mf.string(from: tempMeasurement)
    }
    
    func getPlaceName(weatherInfo: WeatherInfo) -> String? {
        return weatherInfo.name
    }
    
    func getCondition(weatherInfo: WeatherInfo) -> String? {
        return weatherInfo.weather.first?.weatherDescription.uppercased() ?? "--"
    }
    
    func searchLocationWith(location: String) {
        locationViewModel.searchForPlacemark(text: location)
                    .done { [weak self] placeMark in
                        self?.didReceivedLocationData(placeMark: placeMark)
                    }
                    .catch { error in
                        self.didFailedLocationDataWith(error: error as NSError)
                    }
        
    }
    
}


// MARK: - Generic fail function
func brokenPromise<T>(method: String = #function) -> Promise<T> {
    return Promise<T>() { seal in
        let err = NSError(domain: "LloydsAssignment", code: 0, userInfo: [NSLocalizedDescriptionKey: "'\(method)' not yet implemented."])
        seal.reject(err)
    }
}


//MARK: - Extension.

extension WeatherViewModel: LocationDataDelegate {
    func didReceivedLocationData(placeMark: CLPlacemark) {
        if let location = placeMark.location {
            self.getWeatherInfo(coordinate: location.coordinate)
        }
    }
    
    func didFailedLocationDataWith(error: NSError) {
        self.weatherInfoDelegate?.didFailedWeatherInfoWith(error: error)
    }
}

//
//  APIServiceManager.swift
//  LloydsAssignment
//
//  Created by Amit Aman on 23/05/22.
//

import Foundation
import PromiseKit

class APIServiceManager {
    
    var session: URLSession!
    
    // MARK: - Methods
    
    /// Get Weather Data from Open Weather API.
    /// - Parameters:
    ///   - lat: Double
    ///   - long: Double
    ///   - nameSpacer: PMKNamespacer
    /// - Returns: Promise<(data: Data, response: URLResponse)>
    func getWeatherData(with lat: Double,
                        long: Double,
                        nameSpacer: PMKNamespacer) -> Promise<(data: Data, response: URLResponse)> {
        let urlString = ApiURL.weatherInfo + "lat=\(lat)&lon=\(long)&appid=\(AppId.appId)"
        let url = URL(string: urlString)!
        return URLSession.shared.dataTask(nameSpacer, with: url)
    }
    
    /// Get Icon Name from URL.
    /// - Parameters:
    ///   - iconName: String
    ///   - nameSpacer: PMKNamespacer
    /// - Returns: Promise<(data: Data, response: URLResponse)>
    func getIconName(with iconName: String,
                     nameSpacer: PMKNamespacer) -> Promise<(data: Data, response: URLResponse)> {
        let urlString = ApiURL.imageIcon + "\(iconName).png"
        let url = URL(string: urlString)!
        return URLSession.shared.dataTask(nameSpacer, with: url)
    }
    
    
}

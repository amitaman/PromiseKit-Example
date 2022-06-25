//
//  Constants.swift
//  LloydsAssignment
//
//  Created by Amit Aman on 31/05/22.
//

import Foundation

//MARK: - String Constants.
struct Constants {
    static let enable_location_permissions_error = "Enable Location Permissions in Settings."
}



//MARK: - API Constants.
struct ApiURL {

    private struct Domains {
        static let baseUrl = "http://api.openweathermap.org/data/2.5/weather?"
        static let imageUrl = "http://openweathermap.org/img/w/"
    }

  

    static var weatherInfo: String {
        return Domains.baseUrl
    }
    
    static var imageIcon: String {
        return Domains.imageUrl
    }
}

struct AppId {
    private static let appID = "8c572591cd06510bcb4c4f510d652ab1"
    
    static var appId: String {
        return appID
    }
}





//
//  BackendConfiguration.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class BackendConfiguration {
    
    static let host = "notes.mrdekk.ru"
    
    static let authHeader = "Autorization"
    static let contentTypeHeader = "Content-Type"
    
    // PART: OAuthRequest
    
    class OAuthRequest {
        
        static let scheme = "https"
        
        static let host = "oauth.yandex.ru"
        
        static let path = "/authorize"
        
        static let responseTypeName = "responseType"
        static let responseType = "token"
        
        static let clientIdName = "client_id"
        static let clientId = "b810a64aa3454975bb665186bc4350cd"

        static var request = { () -> URL in
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = [
                URLQueryItem(name: responseTypeName, value: responseType),
                URLQueryItem(name: clientIdName, value: clientId)
            ]
            
            return components.url!
        }()
        
    }
    
    // PART: OAuthResponse
    
    class OAuthResponse {
        
        enum Arguments: String {
            
            case accessToken = "access_token"
            
            case expiresIn = "expires_in"
            
            case tokenType = "token_type"
            
            case state = "state"
            
        }
        
    }

}

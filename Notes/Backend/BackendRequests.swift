//
//  Requests.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class BackendRequests {
    
    // PART: Headers
    
    static let authHeader = "Autorization"
    
    static let acceptHeader = "Accept"
    
    static let contentTypeHeader = "Content-Type"
    static let jsonType = "application/json; charset=utf-8"
    
    // PART: Requests

    static func getAll() -> URLRequest? {
        return makeBackendRequest(method: "GET", to: BackendConfiguration.path)
    }
    
    static func get(with uuid: String) -> URLRequest? {
        return makeBackendRequest(method: "GET", to: "\(BackendConfiguration.path)/\(uuid)")
    }
    
    static func post(_ note: Note) -> URLRequest? {
        let serializedNote = try! JSONSerialization.data(withJSONObject: note.json)
        return makeBackendRequest(method: "POST", to: BackendConfiguration.path, with: serializedNote)
    }
    
    static func put(_ note: Note) -> URLRequest? {
        let serializedNote = try! JSONSerialization.data(withJSONObject: note.json)
        return makeBackendRequest(method: "PUT", to: "\(BackendConfiguration.path)/\(note.uuid)", with: serializedNote)
    }
    
    static func delete(_ note: Note) -> URLRequest? {
        let serializedNote = try! JSONSerialization.data(withJSONObject: note.json)
        return makeBackendRequest(method: "delete", to: "\(BackendConfiguration.path)/\(note.uuid)", with: serializedNote)
    }
    
    // MARK: Request builder
    
    private static func makeBackendRequest(method: String, to path: String, with body: Data? = nil) -> URLRequest? {
        // MARK: forming URL
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "http"
        urlComponents.host = BackendConfiguration.host
        urlComponents.path = path
        
        let url = urlComponents.url!
        
        // MARK: creating request
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // MARK: adding headers
        guard let token = UserDefaults.standard.object(forKey: AppDelegate.userAuthSettingName) as? String else {
            return nil
        }
        request.addValue("OAuth \(token)", forHTTPHeaderField: authHeader)
        request.addValue(jsonType, forHTTPHeaderField: acceptHeader)
        request.addValue(jsonType, forHTTPHeaderField: contentTypeHeader)
        
        if let bodyUnwrapped = body {
            request.httpBody = bodyUnwrapped
        }
        
        return request
    }

}

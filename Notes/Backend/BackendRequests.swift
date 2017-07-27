//
//  Requests.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

class BackendRequests {
    
    // PART: - Headers
    
    static let authHeader = "Authorization"
    
    static let acceptHeader = "Accept"
    
    static let contentTypeHeader = "Content-Type"
    static let jsonType = "application/json; charset=utf-8"
    
    // PART: - Requests
    
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
        return makeBackendRequest(method: "DELETE", to: "\(BackendConfiguration.path)/\(note.uuid)", with: serializedNote)
    }
    
    // PART: - Request Builder
    
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
    
    // PART: - Request Completion Handler
    
    static func makeCompletionHandler<T>(of method: String,
                                         using convertion: @escaping (Any) -> T?,
                                         in operation: AsyncOperation<T>)
        -> (Data?, URLResponse?, Error?) -> () {
            return { [weak operation] data, response, error in
                guard let strongOperation = operation else { return }
                
                // MARK: check for error in data task
                if let errorUnwrapped = error {
                    DDLogError("Error in \(method) data task: \(errorUnwrapped.localizedDescription)")
                    strongOperation.cancel()
                    return
                }
                
                guard let dataUnwrapped = data else {
                    DDLogError("No data in \(method) data task")
                    strongOperation.cancel()
                    return
                }
                
                guard let responseJSON = try? JSONSerialization.jsonObject(with: dataUnwrapped) else {
                    DDLogError("\(method) response doesn't seem to be a JSON")
                    strongOperation.cancel()
                    return
                }
                
                // MARK: check for error in server response
                if let response = responseJSON as? [String: Any],
                    let responseError = response["error"] as? Bool,
                    let responseCode = response["code"] as? Int,
                    let responseMessage = response["message"] as? String {
                    if responseError {
                        DDLogError("Wrong \(method) request to server:\n" +
                            "code: \(responseCode)\n" +
                            "message: \(responseMessage)")
                        strongOperation.cancel()
                        return
                    }
                }
                
                // MARK: Argument of type Any is JSON object returned from JSONSerialization.jsonObject(with:)
                guard let result = convertion(responseJSON) else {
                    DDLogError("Wrong \(method) response format")
                    strongOperation.cancel()
                    return
                }
                
                DDLogInfo("\(method) request succeded, response: \(result)")
                strongOperation.success?(result)
                strongOperation.finish()
            }
    }
    
    // PART: - Data Task Performing
    
    static func performDataTask<T>(method: String,
                                   request: URLRequest?,
                                   using convertor: @escaping (Any) -> T?,
                                   in operation: AsyncOperation<T>) {
        guard let strongRequest = request else {
            operation.cancel()
            return
        }
        
        let completionHandler = BackendRequests.makeCompletionHandler(of: method,
                                                                      using: convertor,
                                                                      in: operation)
        
        let task = URLSession.shared.dataTask(with: strongRequest, completionHandler: completionHandler)
        task.resume()
    }
    
}

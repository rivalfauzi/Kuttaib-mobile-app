//
//  ApiRequest.swift
//  Kuttaib
//
//  Created by mco on 19/11/26.
//

import Foundation

final class Session {
    
    static let shared = Session()
    
    private let session: URLSession
    
    private init() {
        let configuration: URLSessionConfiguration = .default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60 // ini untuk file
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        session = URLSession(configuration: configuration)
    }
    
    func request(
        with request: URLRequest,
        callback: @escaping (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask {
        
        let task = session.dataTask(
            with: request, completionHandler: callback
        )
        task.resume()
        
        return task
    }
    
    enum SessionStatus {
        case guest
        case authenticated(token: String)
        case loggedOut
    }
    
    private(set) var status: SessionStatus = .guest
    
    func authenticate(withToken token: String) {
        status = .authenticated(token: token)
    }
    
    func logout() {
        status = .loggedOut
    }
    
    // caching
    private let urlCache = URLCache()
    
    private func cacheRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func cache(_ url: URL) -> CachedURLResponse? {
        return urlCache.cachedResponse(for: cacheRequest(url))
    }
    
    func storeCache(_ url: URL, response: URLResponse,responseBody data: Data) {
        urlCache.storeCachedResponse(
            CachedURLResponse(response: response, data: data),
            for: cacheRequest(url)
        )
    }
}

enum ApiRequest {
    private static let session = Session.shared
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    static func request<Response: Decodable>(
        _ url: URL, method: HTTPMethod = .post,
        additionalHeaders: [String: String]? = nil,
        parameters requestBody: Encodable? = nil,
        callback: @escaping (Result<Response, Error>) -> Void
    ) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let accept = "application/json"
        request.setValue(accept, forHTTPHeaderField: "Accept")
        request.setValue(accept, forHTTPHeaderField: "Content-Type")
        request.setValue(
            "en-ID;q=1.0, id-ID;q=0.9", forHTTPHeaderField: "Accept-Language"
        )
        request.setValue(
            "bt;q=1.0, gzip;q=0.9, deflate;q=0.8", forHTTPHeaderField: "Accept-Encoding"
        )
        
        additionalHeaders?.forEach { field, value in
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        if let requestBody, let encoded = try? JSONEncoder().encode(requestBody) {
            request.httpBody = encoded
        }
        
        return session.request(with: request) { responsebody, response, error in
            if let error {
                if let responsebody, let serialized = try? JSONSerialization.jsonObject(
                    with: responsebody, options: []
                ) as? [String: Any] {
                    callback(.failure(URLError(.badServerResponse, userInfo: serialized)))
                } else {
                    callback(.failure(URLError(.badServerResponse)))
                }
                
                return
            }
            
            if let responsebody, let response = response as? HTTPURLResponse {
                if let decoded = try? JSONDecoder().decode(Response.self, from: responsebody) {
                    callback(.success(decoded))
                } else {
                    callback(.failure(URLError(.cannotDecodeRawData)))
                }
                
                return
            }
            
            callback(.failure(URLError(.unknown)))
        }
    }
}

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
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else { return }
        
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
        cacheable: Bool = false,
        additionalHeaders: [String: String]? = nil,
        parameters requestBody: Encodable? = nil,
        callback: @escaping (Result<Response, Error>) -> Void
    ) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if cacheable, let cachedResponse = session.cache(url),
            let decoded = try? JSONDecoder().decode(Response.self, from: cachedResponse.data) {
            callback(.success(decoded))
            return URLSession.shared.dataTask(with: URLRequest(url: url))
        }
        
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
        
        return session.request(with: request) { responseBody, response, error in
            if let error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
                return
            }
            
            guard let responseBody else {
                DispatchQueue.main.async {
                    callback(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse<Response>.self, from: responseBody)
                
                if apiResponse.success {
                    guard let data = apiResponse.data else {
                        DispatchQueue.main.async {
                            callback(.failure(ApiError(message: "Data kosong")))
                        }
                        
                        return
                    }
                    
                    if cacheable, let response {
                        session.storeCache(url, response: response, responseBody: responseBody)
                    }
                    
                    DispatchQueue.main.async {
                        callback(.success(data))
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(.failure(ApiError(message: apiResponse.message)))
                    }
                }
            } catch {
                print(String(data: responseBody, encoding: .utf8) ?? "")
                
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            }
        }
    }
}

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}

struct ApiError: LocalizedError {

    let message: String

    var errorDescription: String? {
        message
    }
}

//
//  API.swift
//  Squeezee
//
//

import Foundation

// MARK: - API
enum API {
    case sendImage(base64: String, token: String, isFit: Bool)
    case analyzeImage(base64: String, token: String, prompt: String)
}


extension API: APIProtocol {
    var baseURL: String {
        switch self {
        case .sendImage(_, _, let isFit):
            if isFit {
                return "https://fitcheck-4qyvhgerqq-uc.a.run.app"
            } else {
                return "https://analyzeface-4qyvhgerqq-uc.a.run.app"
            }
        case .analyzeImage:
            return "https://visionsearch-4qyvhgerqq-uc.a.run.app"
        }
    }

    var path: String {
        switch self {
        case .sendImage, .analyzeImage:
            return ""
        }
    }

    var method: APIMethod {
        switch self {
        case .sendImage, .analyzeImage:
            return .post
        }
    }

    var task: Request {
        switch self {
        case let .sendImage(base64, _, _):
            return .jsonEncoding(["base64": base64])
        case let .analyzeImage(base64, _, prompt):
            return .jsonEncoding(["base64": base64, "prompt": prompt])
        }
    }

    var header: [String: String] {
        switch self {
        case let .sendImage(_, token, _), let .analyzeImage(_, token, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
}


// MARK: - APIProtocol
/**
 The `APIProtocol` protocol defines the basic properties of an API request.

 - `method`: The HTTP method used for the request.
 - `baseURL`: The base URL of the API endpoint.
 - `path`: The relative path of the API endpoint.
 - `task`: The request task, which contains additional properties such as query parameters, request body, etc.
 - `header`: The request headers.

 The `asURLRequest()` method converts the `APIProtocol` instance to an `URLRequest` instance.

 - If the `task` contains any query parameters, they are added to the URL components.
 - The URL is converted to an `URL` instance.
 - A new `URLRequest` instance is created with the URL.
 - The request headers are added to the `URLRequest`.
 - The HTTP method is set based on the `method` property.
 - If the `task` contains a JSON body, it is converted to `Data` and set as the request body.
 - If the `task` contains a form data, the content type header is set and the request body is set to the form data.

 Note: The `asURLRequest()` method also prints the `curl` command to the debug console for testing purposes.

 */
protocol APIProtocol {
    var method: APIMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var task: Request { get }
    var header: [String: String] { get }

    /**
     Converts the `APIProtocol` instance to an `URLRequest` instance.

     - Returns: The `URLRequest` instance.
     - Throws: An `APIError` if the URL is invalid.
     */
    func asURLRequest() throws -> URLRequest
}

// MARK: - Extension
extension APIProtocol {
    /**
     Converts the `APIProtocol` instance to an `URLRequest` instance.

     - Returns: The `URLRequest` instance.
     - Throws: An `APIError` if the URL is invalid.
     */
    func asURLRequest() throws -> URLRequest {
        guard var urlBuilder = URLComponents(string: baseURL + path) else {
            throw APIError.invalidURL(urlStr: baseURL + path)
        }
        if !task.queryItem.isEmpty {
            urlBuilder.queryItems = task.queryItem
            urlBuilder.percentEncodedQuery = urlBuilder.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        guard let url = urlBuilder.url else {
            throw APIError.invalidURL(urlStr: urlBuilder.url?.absoluteString ?? "")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue.uppercased()
        if let bodyParams = task.jsonBody {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
        }
        if let multiPart = task.formData {
            urlRequest.addValue(multiPart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = multiPart.httpBody
        }
        #if DEBUG
//            print(urlRequest.curlString)
        #endif
        return urlRequest
    }
}

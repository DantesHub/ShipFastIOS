//
//  Enums.swift
//  Squeezee
//
//  Created by iOS Developer on 21/08/23.
//

import Foundation

enum APINetworkService {
    /**
     * Request data from an API endpoint.
     *
     * - Parameters:
     *   - `rout`: The API endpoint to request.
     * - Returns: The decoded data from the API endpoint.
     * - Throws: An error if the request fails.
     */
    static func request<T: Codable>(_ rout: APIProtocol) async throws -> T {
        let (data, res) = try await URLSession.shared.data(for: rout.asURLRequest())
//        print(data, "in the middle of the night")
        let statusCode = (res as? HTTPURLResponse)?.statusCode ?? 400
        switch statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(T.self, from: data)
        default:
            throw APIError.badRequest
        }
    }
    
 /**
         * Request data from an API endpoint and return the response as a string.
         *
         * - Parameters:
         *   - `rout`: The API endpoint to request.
         * - Returns: The response as a string.
         * - Throws: An error if the request fails.
         */
        static func requestString(_ rout: APIProtocol) async throws -> String {
            let (data, res) = try await URLSession.shared.data(for: rout.asURLRequest())
            let statusCode = (res as? HTTPURLResponse)?.statusCode ?? 400
            switch statusCode {
            case 200 ... 299:
                guard let string1 = String(data: data, encoding: .utf8) else {
                    return ""
                }
                
                return string1
            default:
                throw APIError.badRequest
            }
        }
}

// MARK: - APIError
/**
 *  An enumeration of possible errors that can occur when making an API request.
 */
enum APIError: Error {
    /**
     *  Indicates that the API request was not valid.
     */
    case badRequest

    /**
     *  Indicates that the provided URL is not a valid URL.
     */
    case invalidURL(urlStr: String)
}

// MARK: - CustomStringConvertible
/**
 *  A protocol that allows an enumeration to provide a custom description when converted to a string.
 */
extension APIError: CustomStringConvertible {
    /**
     *  Returns a custom description of the error.
     */
    var description: String {
        switch self {
        case .badRequest:
            return "Api request is bad."
        case let .invalidURL(urlStr):
            return "\(urlStr) is invalid url."
        }
    }
}

// MARK: - APIMethod
/**
 *  An enumeration of the supported HTTP methods for making an API request.
 */
enum APIMethod: String {
    /**
     *  Indicates a GET request.
     */
    case get

    /**
     *  Indicates a POST request.
     */
    case post

    /**
     *  Indicates a PUT request.
     */
    case put

    /**
     *  Indicates a PATCH request.
     */
    case patch

    /**
     *  Indicates a DELETE request.
     */
    case delete
}

// MARK: - Request
/**
 *  An enumeration of the supported request types for making an API request.
 */
enum Request {
    /**
     *  Indicates that the request body is JSON-encoded.
     */
    case jsonEncoding(_ model: [String: Any]?)

    /**
     *  Indicates that the request query parameters are provided as a dictionary.
     */
    case queryString(_ dict: [String: Any]?)

    /**
     *  Indicates that the request body is multipart/form-data.
     */
    case multiPart(_ multiPart: MultipartRequest)

    /**
     *  Indicates that the request body is not encoded.
     */
    case requestPlain

    // MARK: - Internal
    /**
     *  Returns the JSON-encoded body of the request.
     */
    var jsonBody: [String: Any]? {
        switch self {
        case let .jsonEncoding(model):
            return model
        case .queryString, .multiPart, .requestPlain: return nil
        }
    }

    /**
     *  Returns the query parameters of the request.
     */
    var queryItem: [URLQueryItem] {
        switch self {
        case .jsonEncoding, .multiPart, .requestPlain:
            return []
        case let .queryString(dict):
            return dict?.asQueryParam ?? []
        }
    }

    /**
     *  Returns the multipart/form-data of the request.
     */
    var formData: MultipartRequest? {
        switch self {
        case .jsonEncoding, .queryString, .requestPlain: return nil
        case let .multiPart(multiPart):
            return multiPart
        }
    }
}




import Foundation

/**
 * A struct for creating multipart/form-data requests.
 */
public struct MultipartRequest {
    // MARK: - Properties
    /**
     The boundary used to separate parts of the request.
     */
    public let boundary: String
    private let separator: String = "\r\n"
    private var data: Data

    // MARK: - Life cycle
    /**
     Initializes a new instance with the specified boundary.

     - Parameter boundary: The boundary to use for separating parts of the request.
     */
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        data = .init()
    }

    // MARK: - Functions
    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)")
    }

    private mutating func appendSeparator() {
        data.append(separator)
    }

    private func disposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }

    /**
     Adds a new part to the request with the specified key and value.

     - Parameter key: The name of the part.
     - Parameter value: The value of the part.
     */
    public mutating func add(key: String, value: String) {
        appendBoundarySeparator()
        data.append(disposition(key) + separator)
        appendSeparator()
        data.append(value + separator)
    }

    /**
     Adds a new file part to the request with the specified key, file name, and file data.

     - Parameter key: The name of the part.
     - Parameter fileName: The name of the file.
     - Parameter fileMimeType: The MIME type of the file.
     - Parameter fileData: The data of the file.
     */
    public mutating func add(key: String, fileName: String, fileMimeType: String, fileData: Data) {
        appendBoundarySeparator()
        data.append(disposition(key) + "; filename=\"\(fileName)\"" + separator)
        data.append("Content-Type: \(fileMimeType)" + separator + separator)
        data.append(fileData)
        appendSeparator()
    }

    /**
     Returns the value to use for the Content-Type header of the HTTP request.

     - Returns: The value for the Content-Type header.
     */
    public var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    /**
     Returns the data to use for the HTTP request body.

     - Returns: The data for the HTTP request body.
     */
    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }
}

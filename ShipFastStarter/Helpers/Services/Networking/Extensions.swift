//
//  Extensions.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import Foundation


/*
Encodes the receiver as JSON data using the JSONEncoder.
- Returns: The JSON data, or `nil` if encoding failed.
*/
public extension Encodable {
   var asDictionary: [String: Any]? {
       guard let data = try? JSONEncoder().encode(self) else {
           return nil
       }
       return (try? JSONSerialization
           .jsonObject(with: data, options: .allowFragments))
           .flatMap { $0 as? [String: Any] }
   }
}

/**
Creates a URLQueryItem array from the dictionary.
- Returns: The URLQueryItem array.
*/
public extension Dictionary where Key == String {
   var asQueryParam: [URLQueryItem] {
       compactMap { key, value in
           let stringValue: String
           if let stringConvertible = value as? CustomStringConvertible {
               stringValue = stringConvertible.description
           } else {
               return nil
           }
           return URLQueryItem(name: key, value: stringValue)
       }
   }
}

/**
Creates a CURL command string from the URLRequest.
- Returns: The CURL command string.
*/
public extension URLRequest {
   var curlString: String {
       guard let url = url else {
           return ""
       }
       var baseCommand = #"curl "\#(url.absoluteString)""#

       if httpMethod == "HEAD" {
           baseCommand += " --head"
       }
       var command = [baseCommand]
       if let method = httpMethod, method != "GET" && method != "HEAD" {
           command.append("-X \(method)")
       }
       if let headers = allHTTPHeaderFields {
           for (key, value) in headers where key != "Cookie" {
               command.append("-H '\(key): \(value)'")
           }
       }
       if let data = httpBody, let body = String(data: data, encoding: .utf8) {
           command.append("-d '\(body)'")
       }
       return command.joined(separator: " \\\n\t")
   }
}

/**
Appends the given string to the end of the data.
- Parameters:
  - string: The string to append.
  - encoding: The encoding to use when converting the string to data.
*/
public extension Data {
   mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
       guard let data = string.data(using: encoding) else {
           return
       }
       append(data)
   }
}

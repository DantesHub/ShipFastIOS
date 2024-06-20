//
//  NetworkManger.swift
//  ShipFastStarter
//
//  Created by Dante Kim on 6/20/24.
//

import Foundation


final class NetworkManager: NetworkService {
//    func sendImage(base64: String, isFit: Bool) async throws -> ResponseModel {
//        return try await APINetworkService.request(API.sendImage(base64: base64, token: "", isFit: isFit))
//    }
    
    func sendFitImage(base64: String, isFit: Bool) async throws -> String {
        return try await APINetworkService.requestString(API.sendImage(base64: base64, token: "", isFit: isFit))
    }
    
    // general OpenAI call
    func analyzeImage(base64: String, prompt: String) async throws -> String {
        return try await APINetworkService.requestString(API.analyzeImage(base64: base64, token: "", prompt: prompt))
    }
}



protocol NetworkService {
    func sendFitImage(base64: String, isFit: Bool) async throws -> String
    func analyzeImage(base64: String, prompt: String) async throws -> String
}

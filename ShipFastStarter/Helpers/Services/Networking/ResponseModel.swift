////
////  ResponseModel.swift
////  ShipFastStarter
////
////  Created by Dante Kim on 6/20/24.
////
//
//import Foundation
//
//
//import Foundation
//import UIKit
//
//// MARK: - ResponseModel
//struct ResponseModel: Codable {
//    let success: Bool?
//    let data: DataModel?
//    let message: String?
//}
//
//struct FitModel: Codable {
//    let success: Bool?
//    let data: DataFitModel?
//    let message: String?
//}
//
//struct DataFitModel: Codable {
//    static func encodeDataModelToJsonString(dataModel: DataFitModel) -> String? {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted // This makes the JSON easier to read if you're debugging
//
//        do {
//            let jsonData = try encoder.encode(dataModel)
//            return String(data: jsonData, encoding: .utf8)
//        } catch {
//            print("Error encoding DataModel to JSON: \(error)")
//            return nil
//        }
//    }
//}
//
//
//
//struct DataModel: Codable {
//    let faceFeatures: FaceFeatures?
//    let colorSeason: ColorSeason?
//    let recommendedColors, colorsToAvoid, neutralColors, accentColors: [AccentColor]?
//    let complementaryAccessories: [ComplementaryAccessory]?
//    let fashionTips: [String]?
//    
//    static func encodeDataModelToJsonString(dataModel: DataModel) -> String? {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted // This makes the JSON easier to read if you're debugging
//
//        do {
//            let jsonData = try encoder.encode(dataModel)
//            return String(data: jsonData, encoding: .utf8)
//        } catch {
//            print("Error encoding DataModel to JSON: \(error)")
//            return nil
//        }
//    }
//}
//
//// MARK: - AccentColor
//struct AccentColor: Codable {
//    let name, hex: String?
//}
//
//// MARK: - ComplementaryAccessory
//struct ComplementaryAccessory: Codable {
//    let material, description: String?
//}

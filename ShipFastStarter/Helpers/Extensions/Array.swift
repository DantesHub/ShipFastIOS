//
//  Array.swift
//  FitCheck
//
//

import Foundation


extension Array<String> {
  func toString() -> String {
    var retStr = ""
    for (idx, item) in self.enumerated() {
      retStr += item
      if idx != self.count - 1 {
        retStr += ", "
      }
    }
    return retStr
  }
}
extension Encodable {
    func toJsonString() -> String? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {return nil}
        return String(data: data, encoding: .utf8)
    }
}

extension Decodable {
    static func fromJsonString(_ jsonString: String) -> Self? {
        guard let data = jsonString.data(using: .utf8) else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode(Self.self, from: data)
    }
}

extension Array<Date> {
  func toString(format: String = "MMM d") -> String {
    var retStr = ""
    for item in self {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      let formatted = dateFormatter.string(from: item)
      retStr += formatted + ", "
    }
    return retStr
  }
}

extension Array where Element: Codable {
    func toJsonStringArray() -> String {
        let array = self.map { $0.toJsonString() ?? "null" }
        return "[" + array.joined(separator: ",") + "]"
    }
    
    static func fromJsonStringArray(_ jsonString: String) -> [Element]? {
        guard let data = jsonString.data(using: .utf8) else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode([Element].self, from: data)
    }
    
    func toJsonStringArrayAsync() async -> String? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let array = self.map { $0.toJsonString() ?? "null" }
                let jsonString = "[" + array.joined(separator: ",") + "]"
                continuation.resume(returning: jsonString)
            }
        }
    }
    
    static func fromJsonStringArrayAsync(_ jsonString: String) async -> [Element]? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let data = jsonString.data(using: .utf8) else {
                    continuation.resume(returning: nil)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let array = try decoder.decode([Element].self, from: data)
                    continuation.resume(returning: array)
                } catch {
                    print("Error decoding JSON string to array: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

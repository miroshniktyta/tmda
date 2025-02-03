import Foundation

struct NetworkLogger {
    static func log(request: URLRequest) {
        print("🌐 [\(Date())] HTTP Request:")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
            print("Body: \(str)")
        }
        print("------------------------")
    }
    
    static func log(response: HTTPURLResponse, data: Data?, error: Error? = nil) {
        print("📥 [\(Date())] HTTP Response:")
        print("URL: \(response.url?.absoluteString ?? "nil")")
        print("Status Code: \(response.statusCode)")
        if let data = data, let str = String(data: data, encoding: .utf8) {
            print("Response Data: \(str)")
        }
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        print("------------------------")
    }
} 

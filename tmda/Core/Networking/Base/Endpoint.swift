import Foundation

protocol Endpoint {
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: String { APIConfig.baseURL }
    var method: HTTPMethod { .get }
    var headers: [String: String] { APIConfig.defaultHeaders }
    var body: Data? { nil }
    var queryItems: [URLQueryItem] { [] }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = APIConfig.apiVersion + path
        components?.queryItems = queryItems
        return components?.url
    }
} 

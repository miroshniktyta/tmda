import Foundation

protocol HTTPClientProtocol {
    func sendRequest<E: Endpoint>(endpoint: E) async throws -> E.Response
}

class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func sendRequest<E: Endpoint>(endpoint: E) async throws -> E.Response {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        #if DEBUG
        NetworkLogger.log(request: request)
        #endif
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        #if DEBUG
        NetworkLogger.log(response: httpResponse, data: data)
        #endif
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }
        
        do {
            return try JSONDecoder().decode(E.Response.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

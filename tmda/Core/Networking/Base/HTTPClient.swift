import Foundation

protocol HTTPClientProtocol {
    func sendRequest<E: Endpoint>(endpoint: E) async -> Result<E.Response, NetworkError>
}

class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    func sendRequest<E: Endpoint>(endpoint: E) async -> Result<E.Response, NetworkError> {
        guard let url = endpoint.url else {
            return .failure(.invalidURL)
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
        
        // Network request
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            return .failure(NetworkError.networkError(error))
        }
        
        // Response validation
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        #if DEBUG
        NetworkLogger.log(response: httpResponse, data: data)
        #endif
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(.serverError(statusCode: httpResponse.statusCode, data: data))
        }
        
        // Response decoding
        do {
            let response = try decoder.decode(E.Response.self, from: data)
            return .success(response)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}

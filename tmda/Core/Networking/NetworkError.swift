import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, data: Data?)
    case noInternetConnection
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .invalidResponse:
            return "The server returned an invalid response"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code, _):
            return "Server error occurred (Status: \(code))"
        case .noInternetConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timed out"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .serverError(let code, let data):
            if let data = data, let message = String(data: data, encoding: .utf8) {
                return "Server returned status code \(code) with message: \(message)"
            }
            return "Server returned status code \(code)"
        case .decodingError(let error):
            return error.localizedDescription
        default:
            return nil
        }
    }
} 

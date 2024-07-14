// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public protocol IStocksAPI {
    func fetchChartData(symbol: String, range: ChartRange) async throws -> ChartData?
    func searchTickers(quote: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
}

public struct StocksAPI: IStocksAPI {

    private let session = URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private let baseURL = "https://apidojo-yahoo-finance-v1.p.rapidapi.com"
    
    public init() {}
    
    public func fetchChartData(symbol: String, range: ChartRange) async throws -> ChartData? {
        guard var urlComponents = URLComponents(string: "\(baseURL)/stock/v3/get-chart") else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = [
            .init(name: "region", value: "US"),
            .init(name: "symbol", value: symbol),
            .init(name: "range", value: range.rawValue),
            .init(name: "interval", value: range.interval)
        ]
                
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        let (response, statusCode): (ChartResponse, Int) = try await fetch(url: url)
        
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.data?.first
    }
    
    public func searchTickers(quote: String, isEquityTypeOnly: Bool = true) async throws -> [Ticker] {
        guard var urlComponents = URLComponents(string: "\(baseURL)/auto-complete") else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [.init(name: "region", value: ""), .init(name: "q", value: quote)]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        let (response, statusCode): (SearchTickersResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        
        if isEquityTypeOnly {
            return (response.data ?? []).filter {
                ($0.quoteType ?? "").localizedCaseInsensitiveCompare("equity") == .orderedSame
            }
        } else {
            return response.data ?? []
        }
    }
    
    public func fetchQuotes(symbols: String) async throws -> [Quote] {
        
        guard var urlComponents = URLComponents(string: "\(baseURL)/market/v2/get-quotes") else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [.init(name: "symbols", value: symbols), .init(name: "region", value: "US")]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        let (response, statusCode): (QuoteResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.data ?? []
        
    }
    
    private func fetch<D: Decodable>(url: URL) async throws -> (D, Int) {
        
        let headers = [
            "x-rapidapi-key": "c4ffb74bfdmsh45aed95501483a0p1a1270jsnccbae628a098",
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request as URLRequest)
        let statusCode = try validateHTTPResponse(response: response)
        return (try jsonDecoder.decode(D.self, from: data), statusCode)
    }
    
    private func validateHTTPResponse(response: URLResponse) throws -> Int {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponseType
        }
        
        guard 200...299 ~= httpResponse.statusCode || 400...499 ~= httpResponse.statusCode else {
            throw APIError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil)
        }
        return httpResponse.statusCode
    }
}

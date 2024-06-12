//
//  Quotes.swift
//
//
//  Created by Sumit Raj on 03/06/24.
//

import Foundation

public struct QuoteResponse: Decodable {
    public let data: [Quote]?
    public let error: ErrorResponse?
    
    enum CodingKeys: CodingKey {
        case quoteResponse
        case finance
    }
    
    enum ResponseKeys: CodingKey {
        case result
        case error
    }
    
    public init(from decoder: any Decoder) throws {
        let quoteContainer = try decoder.container(keyedBy: CodingKeys.self)
        if let quoteResponseContainer = try? quoteContainer.nestedContainer(keyedBy: ResponseKeys.self, forKey: .quoteResponse) {
            self.data = try? quoteResponseContainer.decodeIfPresent([Quote].self, forKey: .result)
            self.error = try? quoteResponseContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
        } else if let financeResponseContainer = try? quoteContainer.nestedContainer(keyedBy: ResponseKeys.self, forKey: .finance) {
            self.data = try? financeResponseContainer.decodeIfPresent([Quote].self, forKey: .result)
            self.error = try? financeResponseContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
        } else {
            self.data = nil
            self.error = nil
        }
    }
}

public struct Quote: Codable, Identifiable, Hashable {
    public let id = UUID()
    
    public let currency: String?
    public let marketState: String?
    public let fullExchangeName: String?
    public let longName: String?
    public let symbol: String?
    public let regularMarketPrice: Double?
    public let regularMarketChange: Double?
    public let regularMarketChangePercent: Double?
    public let regularMarketPreviousClose: Double?
    
    public let postMarketPrice: Double?
    public let postMarketChange: Double?
    public let postMarketChangePercent: Double?
    
    public let regularMarketOpen: Double?
    public let regularMarketDayHigh: Double?
    public let regularMarketDayLow: Double?
    
    public let regularMarketVolume: Double?
    public let trailingPE: Double?
    public let marketCap: Double?
    
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let averageDailyVolume3Month: Double?
    
    public let trailingAnnualDividendYield: Double?
    public let epsTrailingTwelveMonths: Double?
    
    public init(currency: String? = nil, marketState: String? = nil, fullExchangeName: String? = nil, displayName: String? = nil, symbol: String? = nil, regularMarketPrice: Double? = nil, regularMarketChange: Double? = nil, regularMarketChangePercent: Double? = nil, regularMarketPreviousClose: Double? = nil, postMarketPrice: Double? = nil, postMarketChange: Double? = nil, postMarketChangePercent: Double? = nil, regularMarketOpen: Double? = nil, regularMarketDayHigh: Double? = nil, regularMarketDayLow: Double? = nil, regularMarketVolume: Double? = nil, trailingPE: Double? = nil, marketCap: Double? = nil, fiftyTwoWeekLow: Double? = nil, fiftyTwoWeekHigh: Double? = nil, averageDailyVolume3Month: Double? = nil, trailingAnnualDividendYield: Double? = nil, epsTrailingTwelveMonths: Double? = nil) {
        self.currency = currency
        self.marketState = marketState
        self.fullExchangeName = fullExchangeName
        self.longName = displayName
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketChange = regularMarketChange
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketPreviousClose = regularMarketPreviousClose
        self.postMarketPrice = postMarketPrice
        self.postMarketChange = postMarketChange
        self.postMarketChangePercent = postMarketChangePercent
        self.regularMarketOpen = regularMarketOpen
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.trailingPE = trailingPE
        self.marketCap = marketCap
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.trailingAnnualDividendYield = trailingAnnualDividendYield
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
    }
    
}
//can create enum cases of CodingKeys for averageDailyVolume3Month to rename as per convention


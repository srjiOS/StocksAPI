//
//  Chart.swift
//
//
//  Created by Sumit Raj on 05/06/24.
//

import Foundation

public struct ChartResponse: Decodable {
    
    public let data: [ChartData]?
    public let error: ErrorResponse?
    
    enum CodingKeys: CodingKey {
        case chart
    }
    
    enum ChartKeys: CodingKey {
        case result
        case error
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let chartContainer = try? container.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart) {
            data = try? chartContainer.decodeIfPresent([ChartData].self, forKey: .result)
            error = try? chartContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
        } else {
            data = nil
            error = nil
        }
    }
}

public struct ChartData: Decodable {
    
    public let meta: ChartMeta
    public var indicators: [Indicator]
    
    enum CodingKeys: CodingKey {
        case meta
        case timestamp
        case indicators
    }
    
    enum IndicatorKeys: CodingKey {
        case quote
    }
    
    enum QuoteKeys: CodingKey {
        case low
        case high
        case open
        case close
    }
        
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meta = try container.decode(ChartMeta.self, forKey: .meta)
        
        let timeStamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        
        if let indicatorContainer = try? container.nestedContainer(keyedBy: IndicatorKeys.self, forKey: .indicators),
           var quotes = try? indicatorContainer.nestedUnkeyedContainer(forKey: .quote) {
            self.indicators = []
            while !quotes.isAtEnd {
                let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self)
                let highs = try quoteContainer?.decodeIfPresent([Double?].self, forKey: .high) ?? []
                let lows = try quoteContainer?.decodeIfPresent([Double?].self, forKey: .low) ?? []
                let opens = try quoteContainer?.decodeIfPresent([Double?].self, forKey: .open) ?? []
                let closes = try quoteContainer?.decodeIfPresent([Double?].self, forKey: .close) ?? []
                
                self.indicators = timeStamps.enumerated().compactMap({
                    (offset, timeStamp) in
                    guard let open = opens[offset], let close = closes[offset], let high = highs[offset], let low = lows[offset] else {
                        return nil
                    }
                    return .init(timeStamp: timeStamp, open: open, high: high, low: low, close: close)
                })
            }
        } else {
            self.indicators = []
        }
            
    }
    
    public init(meta: ChartMeta, indicators: [Indicator]) {
        self.meta = meta
        self.indicators = indicators
    }

    
}

public struct ChartMeta: Decodable {
    
    public let currency: String
    public let symbol: String
    public let regularMarketPrice: Double?
    public let previousClose: Double?
    public let gmtoffset: Int
    public let regularTradingPeriodStartDate: Date
    public let regularTradingPeriodEndDate: Date
    
    enum CodingKeys: CodingKey {
        case currency
        case symbol
        case regularMarketPrice
        case previousClose
        case gmtoffset
        case currentTradingPeriod
    }
    
    enum CurrentTradingKeys: CodingKey {
        case pre
        case regular
        case post
    }
    
    enum TradingPeriodKeys: CodingKey {
        case start
        case end
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
        self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
        self.gmtoffset = try container.decodeIfPresent(Int.self, forKey: .gmtoffset) ?? 0
        
        let currentTradingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTradingKeys.self, forKey: .currentTradingPeriod)
        let regularTradingPeriodContainer = try? currentTradingPeriodContainer?.nestedContainer(keyedBy: TradingPeriodKeys.self, forKey: .regular)
        self.regularTradingPeriodStartDate = try regularTradingPeriodContainer?.decodeIfPresent(Date.self, forKey: .start) ?? Date()
        self.regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decodeIfPresent(Date.self, forKey: .end) ?? Date()
        
        
    }
}

public struct Indicator: Codable {
    
    public let timeStamp: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    
    public init(timeStamp: Date, open: Double, high: Double, low: Double, close: Double) {
        self.timeStamp = timeStamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
}

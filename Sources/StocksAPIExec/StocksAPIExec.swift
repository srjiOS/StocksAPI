//
//  File.swift
//  
//
//  Created by Sumit Raj on 29/05/24.
//

import Foundation
import StocksAPI

@main
struct StocksAPIExec {
    
    static let stocksAPI = StocksAPI()
    
    static func main() async {
        
        do {
            let quotes = try await stocksAPI.fetchQuotes(symbols: "AAPL,MSFT,TSLA")
          //  print(quotes)
            let tickers = try await stocksAPI.searchTickers(quote: "tesla")
           // print(tickers)
            if let chart = try await stocksAPI.fetchChartData(symbol: "AAPL", range: .oneDay) {
                print(chart)
            }
                
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*
    func testMethod() {
        let headers = [
            "x-rapidapi-key": "c4ffb74bfdmsh45aed95501483a0p1a1270jsnccbae628a098",
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]

//        let request = NSMutableURLRequest(url: URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?region=US&q=tesla")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        let request = NSMutableURLRequest(url: URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v3/get-chart?interval=30m&region=US&symbol=AAPL&range=1d")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)


        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print(error.debugDescription)
            } else {
                if let data {
                   //  let quoteResponse = try? JSONDecoder().decode(QuoteResponse.self, from: data)
                    //let searchTickerResponse = try! JSONDecoder().decode(SearchTickersResponse.self, from: data)
                    let chartResponse = try! JSONDecoder().decode(ChartResponse.self, from: data)

                    print(chartResponse)
                }
            }
            
            semaphore.signal()
        }
        
        dataTask.resume()
        
        semaphore.wait()

    }
     */
    
}



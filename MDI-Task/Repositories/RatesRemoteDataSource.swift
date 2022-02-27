//
//  RatesRemoteDataSource.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import Foundation

protocol RatesDataSource {
    func fetchRates(completion:(RatesResponse?) -> Void)
}

class RemoteDataSource: RatesDataSource {
    func fetchRates(completion: (RatesResponse?) -> Void) {
        
        let response = RatesResponse.init(success: true,
                           base: "",
                           timestamp: 123,
                           date: "22/3/2002",
                           rates: [
                            "AUD": 1.566015,
                            "CAD": 1.560132,
                            "CHF": 1.154727,
                            "CNY": 7.827874,
                            "GBP": 0.882047,
                            "JPY": 132.360679,
                            "USD": 1.23396,
                           ])
        
        completion(response)
    }
}

//
//  RatesResponse.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import Foundation

struct RatesResponse {
    var success: Bool
    var base: String
    var timestamp: Int
    var date: String
    var rates: [String: Double]
}

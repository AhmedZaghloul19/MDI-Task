//
//  ConversionModel.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import Foundation

struct ConversionModel: Codable {
    let primaryCurrency: String?
    let secondaryCurrency: String?
    let primaryValue: Double?
    let secondaryValue: Double?
    let conversionDate: Date?
}

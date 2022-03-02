//
//  ConversionModel.swift
//  MDI-TaskTests
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import Foundation
@testable import MDI_Task

extension ConversionModel: StubProtocol {
    
    static func stub(with date: Date) -> Self {
        let model = ConversionModel(primaryCurrency: "",
                                    secondaryCurrency: "",
                                    primaryValue: 0,
                                    secondaryValue: 0,
                                    conversionDate: date)
        return model
    }
}

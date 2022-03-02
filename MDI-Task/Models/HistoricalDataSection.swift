//
//  HistoricalDataSection.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import Foundation
import RxDataSources

struct HistoricalDataSection {
    var header: String
    var items: [Item]
}

extension HistoricalDataSection: SectionModelType {
    typealias Item = ConversionModel
    
    init(original: HistoricalDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}

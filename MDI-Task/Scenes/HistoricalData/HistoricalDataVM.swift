//
//  HistoricalDataVM.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import RxCocoa

class HistoricalDataVM {
    
    var currenciesHistory: BehaviorRelay<[HistoricalDataSection]> = BehaviorRelay(value: [])

    init() {
        LocalStorageManager.fetchConversions { [weak self] conversions in
            self?.group(conversions: conversions ?? [])
        }
    }
    
    private func group(conversions: [ConversionModel]) {
        let groupedConversions = Dictionary(grouping: conversions) { (element) -> Int in
            let date = Calendar.current
                .dateComponents([.day, .month, .year], from: (element.conversionDate ?? Date()))
            return date.day ?? 0
        }
        let models = groupedConversions.map { (key: Int, value: [ConversionModel]) -> HistoricalDataSection in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM"
            let date = (value.first?.conversionDate ?? Date())
            let dateString = dateFormatter.string(from: date)
            return HistoricalDataSection(header: dateString, items: value)
        }
        currenciesHistory.accept(models)
    }
    
}

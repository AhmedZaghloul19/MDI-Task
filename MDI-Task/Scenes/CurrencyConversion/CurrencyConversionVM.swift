//
//  CurrencyConversionVM.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import Foundation
import RxCocoa

final class CurrencyConversionVM {
    
    let currencies = BehaviorRelay<[String]>(value: [])
    let showLoading = BehaviorRelay<Bool>(value: true)
    let selectedCurrencies = BehaviorRelay<(String, String)>(value: ("", ""))
    let convertedValues = BehaviorRelay<(String, String)>(value: ("1", ""))

    private let fetchRatesUseCase: FetchRatesUseCase?
    private var response: RatesResponse?
    
    init(dataSource: RatesDataSource) {
        self.fetchRatesUseCase = FetchRatesUseCase(repository: dataSource)
    }
    
    func getRates() {
        showLoading.accept(true)
        fetchRatesUseCase?.execute(completion: { [weak self] (response) in
            self?.response = response
            self?.showLoading.accept(false)
            self?.currencies.accept((response?.rates ?? [:])
                .compactMap({ (key: String, value: Double) in
                    return key
                }))
            if (response?.rates.count ?? 0) > 1 {
                self?.selectedCurrencies
                    .accept((self?.currencies.value[0] ?? "",
                             self?.currencies.value[1] ?? ""))
                self?.primaryValueChanged(to: "1")
            }
        })
    }
    
    func primaryCurrencyChanged(to index: Int) {
        selectedCurrencies.accept((currencies.value[index],
                                   selectedCurrencies.value.1))
        primaryValueChanged(to: convertedValues.value.0)
    }
    
    func secondaryCurrencyChanged(to index: Int) {
        selectedCurrencies.accept((selectedCurrencies.value.0,
                                   currencies.value[index]))
        secondaryValueChanged(to: convertedValues.value.1)
    }
    
    func switchCurrencies() {
        selectedCurrencies.accept((selectedCurrencies.value.1,
                                   selectedCurrencies.value.0))
        primaryValueChanged(to: convertedValues.value.0)
    }
    
    func primaryValueChanged(to value: String) {
        guard let valueNum = Double(value) else {return}
        let fromCurrency = response?.rates[selectedCurrencies.value.0] ?? 1.0
        let toCurrency = response?.rates[selectedCurrencies.value.1] ?? 1.0
        
        let convertedVal = (valueNum / fromCurrency) * toCurrency
        let newValue = "\(Double(round(1000*convertedVal)/1000))"
        convertedValues.accept((value, newValue))
    }
    
    func secondaryValueChanged(to value: String) {
        guard let valueNum = Double(value) else {return}
        let fromCurrency = response?.rates[selectedCurrencies.value.0] ?? 1.0
        let toCurrency = response?.rates[selectedCurrencies.value.1] ?? 1.0
        
        let convertedVal = (valueNum / fromCurrency) * toCurrency
        let newValue = "\(Double(round(1000*convertedVal)/1000))"
        convertedValues.accept((newValue, value))
    }
}

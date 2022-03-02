//
//  FetchRatesUseCase.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import Foundation

class FetchRatesUseCase {
    
    var repository: RatesDataSource?
    
    init(repository: RatesDataSource) {
        self.repository = repository
    }

    func execute(completion: @escaping (RatesResponse?, Error?) -> Void) {
        repository?.fetchRates(completion: { (response, error) in
            completion(response, error)
        })
    }
}

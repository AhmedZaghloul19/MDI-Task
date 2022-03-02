//
//  RatesRemoteDataSource.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import Foundation

protocol RatesDataSource {
    func fetchRates(completion: @escaping (RatesResponse?, Error?) -> Void)
}

class RemoteDataSource: RatesDataSource {
    func fetchRates(completion: @escaping (RatesResponse?, Error?) -> Void) {
        let API_KEY = "d438b0d120239d2729b41f5395a7804a"
        let urlRequest = URLRequest(url: URL(string:"http://data.fixer.io/api/latest?access_key=\(API_KEY)")!)
        
        DispatchQueue.global(qos: .background).async {
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    guard response != nil else {
                        completion(nil, error)
                        return
                    }
                    do {
                        let data = try JSONDecoder().decode(RatesResponse.self, from: data ?? Data())
                        completion(data, nil)
                        return
                    } catch {
                        completion(nil, error)
                        return
                    }
                }
            }
            dataTask.resume()
        }
    }
}

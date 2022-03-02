//
//  LocalStorageManager.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import Foundation

public class LocalStorageManager {
        
    private struct constants {
        static let arrayID = "cached-conversions"
    }
    
    /**
     **Get cached local Conversions**.
     ````
     Fetch Conversions
     ````
     - Parameter conversions: array of returned conversions
     */
    static func fetchConversions(callback: @escaping (_ conversions: [ConversionModel]?) -> Void) {
        if let objects = UserDefaults.standard.value(forKey: constants.arrayID) as? Data {
           let decoder = JSONDecoder()
           if let array = try? decoder.decode(Array.self, from: objects) as [ConversionModel] {
               print("✅ Conversions retrieved successfully")
               let lastMonth = Calendar.current.date(byAdding: .day, value: -30, to: Date())!

               let arrayToBeSaved = array.filter { conv in
                   (conv.conversionDate ?? Date()) > lastMonth
               }
               
               let sortedArray = arrayToBeSaved.sorted(by: { ($0.conversionDate ?? Date()).compare($1.conversionDate ?? Date()) == .orderedDescending })
               
               callback(sortedArray)
           } else {
               callback(nil)
               print("❌ Failed to Decode Conversions")
           }
        } else {
            callback(nil)
            print("❌ Failed to fetch Conversions")
        }
    }
    
    /**
     **Save Conversion to local storage**.
     ````
     Save Conversion
     ````
     - Parameter conversion: conversion to be saved
     */
    static func save(conversion: ConversionModel) -> Void {
        fetchConversions { conversions in
            var convs = conversions ?? []
            convs.append(conversion)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(convs){
                UserDefaults.standard.set(encoded, forKey: constants.arrayID)
                print("✅ Conversation Saved successfully")
            } else {
                print("❌ Failed to save Conversion")
            }
        }
    }
    
    /**
     **Save Conversions to local storage**.
     ````
     Save Conversions
     ````
     - Parameter conversions: conversions to be saved
     */
    static func save(conversions: [ConversionModel]) -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(conversions){
            UserDefaults.standard.set(encoded, forKey: constants.arrayID)
            print("✅ Conversations Saved successfully")
        } else {
            print("❌ Failed to save Conversions")
        }
    }
}

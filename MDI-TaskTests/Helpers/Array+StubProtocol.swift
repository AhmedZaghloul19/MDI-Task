//
//  Array+StubProtocol.swift
//  MDI-TaskTests
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import Foundation

extension Array where Element: StubProtocol {

   static func stub(withCount count: Int) -> Array {
       return (1...count).map {_ in
           .stub(with: Date())
       }
   }
}

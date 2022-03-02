//
//  CurrencyConversionTest.swift
//  MDI-TaskTests
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import MDI_Task

class CurrencyConversionTest: XCTestCase {

    var mockedRemoteAPI: MockedRemoteDataSource!
    var viewModel: CurrencyConversionVM!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        mockedRemoteAPI = MockedRemoteDataSource()
        viewModel = CurrencyConversionVM(dataSource: mockedRemoteAPI)
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testGetCurrenciesData() {
        viewModel.getRates()
        let observable = viewModel.currencies
            .map { $0.count }
        XCTAssertNotEqual(try observable.toBlocking().first(), 0)
    }
    
    func testLoadingIndicator() {
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.showLoading
            .bind(to: observer)
            .disposed(by: disposeBag)
                
        scheduler.scheduleAt(1) { [self] in
            viewModel.getRates()
        }
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .next(0, true),
            .next(1, true),
            .next(1, false),
        ])
    }
}

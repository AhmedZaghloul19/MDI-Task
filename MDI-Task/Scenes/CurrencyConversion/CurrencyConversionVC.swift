//
//  CurrencyConversionVC.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import UIKit
import RxSwift

class CurrencyConversionVC: UIViewController {

    //MARK: - IBOutlets.
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyPrimaryTextField: UITextField!
    @IBOutlet weak var currencySecondaryTextField: UITextField!
    
    @IBOutlet weak var valuePrimaryTextField: UITextField!
    @IBOutlet weak var valueSecondaryTextField: UITextField!
    
    //MARK: - Variables
    private var viewModel: CurrencyConversionVM?
    private var disposeBag = DisposeBag()
    
    lazy var primaryPickerView: UIPickerView = {
        return UIPickerView()
    }()
    
    lazy var secondaryPickerView: UIPickerView = {
        return UIPickerView()
    }()

    convenience init(viewModel: CurrencyConversionVM) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPrimaryTextField.inputView = primaryPickerView
        currencySecondaryTextField.inputView = secondaryPickerView
        
        bindViewModel()
        viewModel?.getRates()
        setupNavigationBar()
    }
    
    func bindViewModel() {

        viewModel?.showLoading.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel?.currencies
            .bind(to: primaryPickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        viewModel?.currencies
            .bind(to: secondaryPickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
    
        viewModel?.selectedCurrencies
            .bind(onNext: {[weak self] (primary, secondary) in
                self?.currencyPrimaryTextField.text = primary
                self?.currencySecondaryTextField.text = secondary
            })
            .disposed(by: disposeBag)
        
        primaryPickerView.rx.itemSelected
            .bind(onNext: {[weak self] (row: Int, component: Int) in
                self?.viewModel?.primaryCurrencyChanged(to: row)
            })
            .disposed(by: disposeBag)
        
        secondaryPickerView.rx.itemSelected
            .bind(onNext: {[weak self] (row: Int, component: Int) in
                self?.viewModel?.secondaryCurrencyChanged(to: row)
            })
            .disposed(by: disposeBag)
        
        viewModel?.convertedValues
            .bind(onNext: {[weak self] convValue in
                self?.valuePrimaryTextField.text = convValue.0
                self?.valueSecondaryTextField.text = convValue.1
            })
            .disposed(by: disposeBag)
        
        valuePrimaryTextField.rx.controlEvent([.editingChanged])
            .bind(onNext: {[weak self] _ in
                self?.viewModel?.primaryValueChanged(to: self?.valuePrimaryTextField.text ?? "")
            })
            .disposed(by: disposeBag)
        
        valueSecondaryTextField.rx.controlEvent([.editingChanged])
            .bind(onNext: {[weak self] _ in
                self?.viewModel?.secondaryValueChanged(to: self?.valueSecondaryTextField.text ?? "")
            })
            .disposed(by: disposeBag)
        
        viewModel?.failureState
            .bind(onNext: {[weak self] error in
                guard !error.isEmpty else {return}
                let alertController = UIAlertController(title: "Failed",
                                                        message: error,
                                                        preferredStyle: .alert)
                let action = UIAlertAction(title: "Retry", style: .default) {
                    UIAlertAction in
                    self?.viewModel?.getRates()
                }
                alertController.addAction(action)
                
                self?.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
            
    }
    
    func setupNavigationBar() {
        let historyItem = UIBarButtonItem(image: UIImage(named: "list"),
                                      style: UIBarButtonItem.Style.plain,
                                      target: self,
                                      action: #selector(showHistoryTapped))
        navigationItem.rightBarButtonItem = historyItem
    }
    
    @objc func showHistoryTapped() {
        let vm = HistoricalDataVM()
        let vc = HistoricalDataVC(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func switchCurrencies() {
        viewModel?.switchCurrencies()
    }

}

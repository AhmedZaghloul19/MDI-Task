//
//  HistoricalDataVC.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import UIKit
import RxSwift
import RxDataSources

class HistoricalDataVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var viewModel: HistoricalDataVM?
    private var disposeBag = DisposeBag()
    
    private struct constants {
        static let conversionCellName = "ConversionHistoryCell"
    }

    convenience init(viewModel: HistoricalDataVM) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        let nib = UINib(nibName: constants.conversionCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: constants.conversionCellName)
        let dataSource = RxTableViewSectionedReloadDataSource<HistoricalDataSection>(
            configureCell: { (_, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: constants.conversionCellName, for: indexPath) as! ConversionHistoryCell
                cell.setup(with: element)
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].header
            }
        )
        
        viewModel?.currenciesHistory
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }

}

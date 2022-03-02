//
//  ConversionHistoryCell.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 02/03/2022.
//

import UIKit

class ConversionHistoryCell: UITableViewCell {
    
    @IBOutlet weak var primaryCurrencyLabel: UILabel!
    @IBOutlet weak var secondaryCurrencyLabel: UILabel!
    
    @IBOutlet weak var primaryValueLabel: UILabel!
    @IBOutlet weak var secondaryValueLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!

    func setup(with model: ConversionModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        timeLabel.text = dateFormatter.string(from: model.conversionDate ?? Date())
        
        primaryCurrencyLabel.text = model.primaryCurrency ?? ""
        secondaryCurrencyLabel.text = model.secondaryCurrency ?? ""
        
        primaryValueLabel.text = "\(model.primaryValue ?? 0.0)"
        secondaryValueLabel.text = "\(model.secondaryValue ?? 0.0)"
    }
    
}

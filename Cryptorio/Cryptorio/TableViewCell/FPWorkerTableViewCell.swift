//
//  FPWorkerTableViewCell.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/14/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import UIKit

class FPWorkerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var workerNameLabel: UILabel!
  @IBOutlet weak var hashRateLabel: UILabel!
  
  override func prepareForReuse() {
    contentView.backgroundColor = UIColor.white
  }
  
  func bind(to model: FPHTMLWorker) {
    workerNameLabel.text = model.workerName
    hashRateLabel.text = "\(model.currentHashrate) - \(model.avgHashrate)"
    
    if (model.currentHashrate == "0 H/s") {
      contentView.backgroundColor = UIColor(red: 239/250, green: 214/250, blue: 214/250, alpha: 1)
    }
  }
}

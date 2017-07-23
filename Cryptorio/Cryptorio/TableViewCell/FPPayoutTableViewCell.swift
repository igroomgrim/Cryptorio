//
//  FPPayoutTableViewCell.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/23/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import UIKit

class FPPayoutTableViewCell: UITableViewCell {
  
  @IBOutlet weak var paidOnLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  override func prepareForReuse() {

  }
  
  func bind(to model: FPHTMLPayout) {
    amountLabel.text = model.amount
    durationLabel.text = model.durationHour
    paidOnLabel.text = "paid on : \(model.paidOn)"
  }
}

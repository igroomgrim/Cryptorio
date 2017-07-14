//
//  FPWorkerListWorker.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/14/17.
//  Copyright (c) 2017 iGROOMGRiM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class FPWorkerListWorker {
  func fetchWorkers(walletID: String, completion: @escaping ([FPHTMLWorker]?) -> Void) {
    HTMLParser.parseWorkersTable(walletID: walletID, completion: completion)
  }
  
  func fetchWalletID() -> String? {
    return WalletIDStore.getWalletID(from: .flypool)
  }
}

//
//  APIEndpoint.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/19/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

enum FPEndpoint {
  case dashboard
  case worker
  case payout
  case estimatedEarning
}

struct APIEndpoint<DataType: FPObject> {
  
  public typealias Result = DataType
  
  private let endpointString: String
  let url: URL
  
  init(endpoint: FPEndpoint, walletID: String) {
    switch endpoint {
    case .dashboard, .worker:
      self.endpointString = "http://zcash.flypool.org/api/miner_new/\(walletID)"
    case .payout, .estimatedEarning:
      self.endpointString = "http://zcash.flypool.org/api/miner_new/\(walletID)/payouts"
    }
    
    self.url = URL(string: self.endpointString)!
  }
}

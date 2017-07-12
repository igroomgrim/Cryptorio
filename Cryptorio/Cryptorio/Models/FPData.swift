//
//  FPData.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/11/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

struct FPData: Decodable {
  let address: String
  let hashRate: String
  /*
  let ethPerMin: Double
  let usdPerMin: Double
  let btcPerMin: Double
  let avgHashrate: Double
  let unpaid: Double
  let payouts: [FPPayout]
  let workers: [FPWorker]
  */
  
  init?(json: JSON) {
    guard let address = json["address"] as? String,
    let hashRate = json["hashRate"] as? String else {
      return nil
    }
    
    self.address = address
    self.hashRate = hashRate
  }
}

struct FPPayout {
  let id: Double
  let miner: String
  let start: Double
  let end: Double
  let amount: Double
  let txHash: String
  let paidOn: Date
}

struct FPWorker {
  let worker: [String: Any]
}

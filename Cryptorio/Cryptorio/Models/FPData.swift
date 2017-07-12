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
  
  let ethPerMin: Double
  let usdPerMin: Double
  let btcPerMin: Double
  let avgHashrate: Double
  let unpaid: Double
  /*
  let payouts: [FPPayout]
  let workers: [FPWorker]
  */
  
  init?(json: JSON) {
    guard let address = json["address"] as? String,
    let hashRate = json["hashRate"] as? String,
    let ethPerMin = json["ethPerMin"] as? Double,
    let usdPerMin = json["usdPerMin"] as? Double,
    let btcPerMin = json["btcPerMin"] as? Double,
    let avgHashrate = json["avgHashrate"] as? Double,
    let unpaid = json["unpaid"] as? Double else {
      return nil
    }
    
    self.address = address
    self.hashRate = hashRate
    self.ethPerMin = ethPerMin
    self.usdPerMin = usdPerMin
    self.btcPerMin = btcPerMin
    self.avgHashrate = avgHashrate
    self.unpaid = unpaid/100_000_000
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

struct FPRound {
  let id: Double
  let miner: String
  let block: Double
  let work: Double
  let amount: Double
  let processed: Int
}

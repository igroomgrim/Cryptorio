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
  let rounds: [FPRound]?
  let payouts: [FPPayout]?
  let workers: [FPWorker]?
  
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
    self.avgHashrate = avgHashrate/1000
    self.unpaid = unpaid/100_000_000

    if let rounds = (json["rounds"] as? [JSON])?.flatMap(FPRound.init) {
      self.rounds = rounds
    } else {
      self.rounds = nil
    }
    
    if let payouts = (json["payouts"] as? [JSON])?.flatMap(FPPayout.init) {
      self.payouts = payouts
    } else {
      self.payouts = nil
    }
    
    self.workers = (json["workers"] as? [String: JSON]).map { (wks) -> [FPWorker] in
      return wks.flatMap({ (wk) -> FPWorker? in
        return FPWorker(json: wk.value)
      })
    }
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
  
  init?(json: JSON) {
    guard let id = json["id"] as? Double,
      let miner = json["miner"] as? String,
      let start = json["start"] as? Double,
      let end = json["end"] as? Double,
      let amount = json["amount"] as? Double,
      let txHash = json["txHash"] as? String,
      let paidOn = DateConverter.convert(fromAttribute: json["paidOn"]) else {
        return nil
    }
    
    self.id = id
    self.miner = miner
    self.start = start
    self.end = end
    self.amount = amount
    self.txHash = txHash
    self.paidOn = paidOn
  }
}

struct FPWorker {
  let workerName: String
  let hashRate: String
  let validShares: Int
  let invalidShares: Int
  let workerLastSubmitTime: Int
  let staleShares: Int
  let invalidShareRatio: Double
  
  init?(json: JSON) {
    guard let workerName = json["worker"] as? String,
      let hashRate = json["hashrate"] as? String,
      let validShares = json["validShares"] as? Int,
      let invalidShares = json["invalidShares"] as? Int,
      let workerLastSubmitTime = json["workerLastSubmitTime"] as? Int,
      let staleShares = json["staleShares"] as? Int,
      let invalidShareRatio = json["invalidShareRatio"] as? Double else {
        return nil
    }
    
    self.workerName = workerName
    self.hashRate = hashRate
    self.validShares = validShares
    self.invalidShares = invalidShares
    self.workerLastSubmitTime = workerLastSubmitTime
    self.staleShares = staleShares
    self.invalidShareRatio = invalidShareRatio
  }
}

struct FPRound {
  let id: Double
  let miner: String
  let block: Double
  let work: Double
  let amount: Double
  let processed: Int
  
  init?(json: JSON) {
    guard let id = json["id"] as? Double,
    let miner = json["miner"] as? String,
    let block = json["block"] as? Double,
    let work = json["work"] as? Double,
    let amount = json["amount"] as? Double,
    let processed = json["processed"] as? Int else {
      return nil
    }
    
    self.id = id
    self.miner = miner
    self.block = block
    self.work = work
    self.amount = amount
    self.processed = processed
  }
}

struct FPHTMLWorker {
  let workerName: String
  let currentHashrate: String
  let avgHashrate: String
  let validShares: String
  let invalidShares: String
  
  init?(wk: [String?]) {
    guard let workerName = wk[0],
      let currentHashrate = wk[1],
      let avgHashrate = wk[2],
      let validShares = wk[3],
      let invalidShares = wk[4] else {
        return nil
    }
    
    self.workerName = workerName
    self.currentHashrate = currentHashrate
    self.avgHashrate = avgHashrate
    self.validShares = validShares
    self.invalidShares = invalidShares
  }
}

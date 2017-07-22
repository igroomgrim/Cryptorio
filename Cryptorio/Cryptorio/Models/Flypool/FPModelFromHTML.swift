//
//  FPModelFromHTML.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/19/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

struct FPHTMLWorker: FPHTMLObject {
  let workerName: String
  let currentHashrate: String
  let avgHashrate: String
  let validShares: String
  let invalidShares: String
  
  var endpoint: FPEndpoint
  
  init?(json: JSON) {
    return nil
  }
  
  init?(html object: [String?]) {
    guard let workerName = object[0],
      let currentHashrate = object[1],
      let avgHashrate = object[2],
      let validShares = object[3],
      let invalidShares = object[4] else {
        return nil
    }
    
    self.workerName = workerName
    self.currentHashrate = currentHashrate
    self.avgHashrate = avgHashrate
    self.validShares = validShares
    self.invalidShares = invalidShares
    self.endpoint = .worker
  }
}

struct FPHTMLPayout: FPHTMLObject {
  let paidOn: String
  let fromBlock: String
  let toBlock: String
  let durationHour: String
  let amount: String
  let txHash: String
  
  var endpoint: FPEndpoint
  
  init?(json: JSON) {
    return nil
  }
  
  init?(html object: HTML) {
    guard let paidOn = object[0],
      let fromBlock = object[1],
      let toBlock = object[2],
      let durationHour = object[3],
      let amount = object[4],
      let txHash = object[5] else {
        return nil
    }
    
    self.paidOn = paidOn
    self.fromBlock = fromBlock
    self.toBlock = toBlock
    self.durationHour = durationHour
    self.amount = amount
    self.txHash = txHash
    self.endpoint = .payout
  }
}

struct FPHTMLEstEarningTime: FPHTMLObject {
  let period: String
  let zec: String
  let usd: String
  let btc: String
  
  var endpoint: FPEndpoint
  
  init?(json: JSON) {
    return nil
  }
  
  init?(html object: HTML) {
    guard let period = object[0],
      let zec = object[1],
      let usd = object[2],
      let btc = object[3] else {
        return nil
    }
    
    self.period = period
    self.zec = zec
    self.usd = usd
    self.btc = btc
    
    self.endpoint = .estimatedEarning
  }
}

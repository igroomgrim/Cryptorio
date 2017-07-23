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

enum FPDataType {
  case json
  case html
}

struct APIEndpoint<TObject: FPObject> {
  
  public typealias Result = TObject
  private let endpoint: FPEndpoint
  private let endpointString: String
  let url: URL
  let dataType: FPDataType
  
  init(endpoint: FPEndpoint, walletID: String) {
    let apiURL = "http://zcash.flypool.org/api/miner_new"
    let htmlURL = "http://zcash.flypool.org/miners"
    
    switch endpoint {
    case .dashboard:
      self.endpointString = "\(apiURL)/\(walletID)"
    case .worker:
      self.endpointString = "\(htmlURL)/\(walletID)"
    case .payout, .estimatedEarning:
      self.endpointString = "\(htmlURL)/\(walletID)/payouts"
    }
    self.endpoint = endpoint
    self.url = URL(string: self.endpointString)!
    
    guard endpoint != FPEndpoint.dashboard else {
      self.dataType = .json
      return
    }
    
    self.dataType = .html
  }
  
  func deserialize(_ data: Data) -> (TObject?, [TObject]?) {
    switch self.dataType {
    case .json:
      return (TObject(data: data), nil)
    
    case .html:
      let htmlSerializer = CryptorioHTMLSerializer()
      guard let doc = htmlSerializer.html(from: data) else {
        return (nil, nil)
      }

      switch self.endpoint {
      case .dashboard, .worker:
        let workers = HTMLParser<TObject>.parseWorkerObjects(doc: doc)
        return (nil, workers)
      case .payout:
        return (nil, nil)
      case .estimatedEarning:
        let estimatedEarnings = HTMLParser<TObject>.parseEstimatedTimeObjects(doc: doc)
        return (nil, estimatedEarnings)
      }
    }
  }
}

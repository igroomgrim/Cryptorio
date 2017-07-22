//
//  HTMLParser.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/12/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation
import Kanna

enum ParseDataType {
  case worker
  case payout
  case estimatedEarning
}

class HTMLParser<Result: FPHTMLObject> {
  let doc: HTMLDocument
  
  init(doc: HTMLDocument) {
    self.doc = doc
  }
  
  func objects() -> [Result]? {
    var tempObjects: [[String?]] = []
    return nil
  }
  
  class func parseWorkerObjects(doc: HTMLDocument) -> [FPHTMLWorker]? {
    var tempObjects: [[String?]] = []
    
    for trData in doc.xpath("//table/tbody/tr") {
      var tempArr: [String?] = []
      for tdData in trData.xpath("td") {
        tempArr.append(tdData.text)
      }
      
      tempObjects.append(tempArr)
    }
    
    print(tempObjects[0])
    let workers = tempObjects.flatMap(FPHTMLWorker.init(html:))
    
    return workers
  }
  
  private class func parsePayoutObjects(doc: HTMLDocument) -> [FPHTMLPayout] {
    return []
  }
  
  private class func parseEstimatedTimeObjects(doc: HTMLDocument) -> [FPHTMLEstEarningTime] {
    var tempObjects: [[String?]] = []
    
    let estEarningTableIndex = 1
    var indexCount = 0
    
    for tbData in doc.xpath("//table") {
      for trData in tbData.xpath("tr").dropFirst() {
        guard indexCount == estEarningTableIndex else {
          continue
        }
        
        var tempArr: [String?] = []
        for td in trData.xpath("td") {
          tempArr.append(td.text)
          
        }
        
        tempObjects.append(tempArr)
      }
      
      indexCount += 1
    }
    
    let estEarningTimes = tempObjects.flatMap(FPHTMLEstEarningTime.init(html:))
    
    return estEarningTimes
  }
  
  class func xxxx(type: ParseDataType, walletID: String, completion: @escaping ([FPHTMLWorker]?) -> Void) {
    parseArrayDataFromTable(parseDataType: type, walletID: walletID, completion: completion)
  }
  
  class func request(walletID: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard let url = URL(string: "http://zcash.flypool.org/miners/\(walletID)/payouts") else {
      return
    }
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    dataTask = defaultSession.dataTask(with: url, completionHandler: completionHandler)
    
    dataTask?.resume()
  }
  
  class func parseArrayDataFromTable<T: FPObject>(parseDataType: ParseDataType, walletID: String, completion: @escaping ([T]?) -> Void) {
    guard let url = URL(string: "http://zcash.flypool.org/miners/\(walletID)/payouts") else {
      completion(nil)
      return
    }
        
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    dataTask = defaultSession.dataTask(with: url) { data, response, error in
      defer { dataTask = nil }
      if let _ = error {
        DispatchQueue.main.async {
          completion(nil)
        }
      } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        guard let doc = HTML(html: data, encoding: .utf8) else {
          DispatchQueue.main.async {
            completion(nil)
          }
          return
        }

        DispatchQueue.main.async {
//          completion(T)
        }
        
      }
    }
    
    dataTask?.resume()
  }
  
  
  class func parseWorkersTable(walletID: String, completion: @escaping ([FPHTMLWorker]?) -> Void) {
    guard let url = URL(string: "http://zcash.flypool.org/miners/\(walletID)") else {
      completion(nil)
      return
    }
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    dataTask = defaultSession.dataTask(with: url) { data, response, error in
      defer { dataTask = nil }
      if let _ = error {
        DispatchQueue.main.async {
          completion(nil)
        }
      } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        guard let doc = HTML(html: data, encoding: .isoLatin1) else {
          DispatchQueue.main.async {
            completion(nil)
          }
          return
        }
        
        let workers = parseWorkerObjects(doc: doc)
        
        DispatchQueue.main.async {
          completion(workers)
        }
        
      }
    }
    
    dataTask?.resume()
  }
}

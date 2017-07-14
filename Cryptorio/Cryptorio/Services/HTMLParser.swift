//
//  HTMLParser.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/12/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation
import Kanna

class HTMLParser {
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
        
        var tempData: [[String?]] = []
        
        for trData in doc.xpath("//table/tbody/tr") {
          var tempArr: [String?] = []
          for tdData in trData.xpath("td") {
            tempArr.append(tdData.text)
          }
          
          tempData.append(tempArr)
        }
        
        let workers = tempData.flatMap(FPHTMLWorker.init(wk:))
        DispatchQueue.main.async {
          completion(workers)
        }
        
      }
    }
    
    dataTask?.resume()
  }
}

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
  class func parseWorkersTable(walletID: String) -> [FPHTMLWorker]? {
    guard let url = URL(string: "http://zcash.flypool.org/miners/\(walletID)") else {
      return nil
    }
    
    if let doc = HTML(url: url, encoding: .isoLatin1) {
      var tempData: [[String?]] = []
      
      for trData in doc.xpath("//table/tbody/tr") {
        var tempArr: [String?] = []
        for tdData in trData.xpath("td") {
          tempArr.append(tdData.text)
        }
        
        tempData.append(tempArr)
      }
            
      let workers = tempData.flatMap(FPHTMLWorker.init(wk:))
      return workers
    } else {
      return nil
    }
  }
}

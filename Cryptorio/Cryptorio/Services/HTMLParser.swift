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


class HTMLParser<TObject: FPObject> {
  class func parseWorkerObjects(doc: HTMLDocument) -> [TObject]? {
    var tempObjects: [[String?]] = []

    for trData in doc.xpath("//table/tbody/tr") {
      var tempArr: [String?] = []
      for tdData in trData.xpath("td") {
        tempArr.append(tdData.text)
      }
      
      tempObjects.append(tempArr)
    }

    let workers = tempObjects.flatMap(TObject.init(html:))
    
    return workers
  }
  
  class func parsePayoutObjects(doc: HTMLDocument) -> [TObject] {
    var tempObjects: [[String?]] = []
    
    let payoutTableIndex = 0
    var indexCount = 0
    
    for tbData in doc.xpath("//table") {
      for trData in tbData.xpath("tr").dropFirst() {
        guard indexCount == payoutTableIndex else {
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
    
    let payouts = tempObjects.flatMap(TObject.init(html:))

    return payouts
  }
  
  class func parseEstimatedTimeObjects(doc: HTMLDocument) -> [TObject] {
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
    
    let estEarningTimes = tempObjects.flatMap(TObject.init(html:))
    
    return estEarningTimes
  }
}

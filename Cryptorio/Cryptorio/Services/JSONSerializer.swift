//
//  JSONSerializer.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/11/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation
import Kanna

typealias JSON = [String: Any]

protocol JSONSerializer {
  func json(from data: Data, options: JSONSerialization.ReadingOptions) -> JSON?
}

struct CryptorioJSONSerializer: JSONSerializer {
  func json(from data: Data, options: JSONSerialization.ReadingOptions) -> JSON? {
    guard let json = (try? JSONSerialization.jsonObject(with: data, options: options)) as? JSON else {
      return nil
    }
    
    return json
  }
}

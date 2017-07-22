//
//  Decodable.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

//
//  Decoable.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

protocol Decodable {
  init?(json: JSON)
  init?(html: [String?])
}

extension Decodable {
  init?(data: Data, serializer: JSONSerializer = CryptorioJSONSerializer(), options: JSONSerialization.ReadingOptions = .mutableContainers) {
    if let json = serializer.json(from: data, options: options) {
      self.init(json: json)
      return
    }
    
    return nil
  }
  
  init?(htmlData: Data, serializer: HTMLSerializer = CryptorioHTMLSerializer()) {
    return nil
  }
}

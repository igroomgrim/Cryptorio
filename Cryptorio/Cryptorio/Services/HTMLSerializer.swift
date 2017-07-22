//
//  HTMLSerializer.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation
import Kanna

typealias HTMLData = [String?]

protocol HTMLSerializer {
  func html(from data: Data) -> HTMLDocument?
}

struct CryptorioHTMLSerializer: HTMLSerializer {
  func html(from data: Data) -> HTMLDocument? {
    guard let htmlDoc = HTML(html: data, encoding: .utf8) else {
      return nil
    }
    
    return htmlDoc
  }
}

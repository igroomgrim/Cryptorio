//
//  FPObject.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/17/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

protocol FPObject: Decodable {
  typealias JSON = [String: Any]
  typealias HTML = [String?]
}

protocol FPJSONObject: FPObject {
  init?(json: JSON)
}

protocol FPHTMLObject: FPObject {
  init?(html: HTML)
}

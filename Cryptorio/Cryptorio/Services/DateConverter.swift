//
//  DateConverter.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/12/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import Foundation

class DateConverter {
  static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
    return formatter
  }()
  
  public static func convert(fromAttribute value: Any?) -> Date? {
    guard let s = value as? String else { return nil }
    return formatter.date(from: s)
  }
}

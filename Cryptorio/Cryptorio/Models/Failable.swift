//
//  Failable.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

enum Failable<TResult> {
  case success(TResult)
  case fail(FPError)
  
  func value() -> Any {
    switch self {
    case .success(let result):
      return result
    case .fail(let error):
      return error
    }
  }
  
  public func map<T>(_ transform: (TResult) -> T) -> Failable<T> {
    switch self {
    case .success(let result):
      return Failable<T>.success(transform(result))
    case .fail(let error):
      return Failable<T>.fail(error)
    }
  }
 
  
}

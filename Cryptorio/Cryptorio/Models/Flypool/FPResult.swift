//
//  FPResult.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/19/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

enum FPResult<U> {
  case Success(result: U)
  case Failure(error: FPError)
}

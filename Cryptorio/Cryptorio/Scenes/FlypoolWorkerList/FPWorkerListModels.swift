//
//  FPWorkerListModels.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/14/17.
//  Copyright (c) 2017 iGROOMGRiM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum FPWorkerList {
  // MARK: Use cases
  
  enum GetWorkers {
    struct Request {
    }
    struct Response {
      var fpWorkers: [FPHTMLWorker]?
    }
    struct ViewModel {
      var displayedFPWorkers: [FPHTMLWorker]?
    }
  }
}

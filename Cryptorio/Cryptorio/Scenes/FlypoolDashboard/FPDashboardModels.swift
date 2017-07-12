//
//  FPDashboardModels.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/11/2560 BE.
//  Copyright (c) 2560 iGROOMGRiM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum FPDashboard {
  // MARK: Use cases
  
  enum RequestData {
    struct Request {
    }
    
    struct Response {
      let flypoolData: FPData
    }
    
    struct ViewModel {
      struct DashboardData {
        let address: String
        let hashRate: String
        let avgHashRate: String
        let unpaidBalance: Double
        
        init(responseData: FPData) {
          self.address = responseData.address
          self.hashRate = responseData.hashRate
          self.avgHashRate = String(format: "%.2f", responseData.avgHashrate)
          self.unpaidBalance = responseData.unpaid
        }
      }
      
      var displayedDashboardData: DashboardData
    }
  }
  
  enum ErrorData {
    struct Request {
    }
    
    struct Response {
      let error: FPError
    }
    
    struct ViewModel {
      struct DashboardError {
        let error: FPError
        
        init(responseError: FPError) {
          self.error = responseError
        }
      }
      
      var displayedDashboardError: DashboardError
    }
  }
}

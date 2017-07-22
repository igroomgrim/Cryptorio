//
//  FPDashboardWorker.swift
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

class FPDashboardWorker {
  let defaultSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?
  
  func fetchAPIData(walletID: String, completion: @escaping (FPResult<FPData>) -> Void) {
    
    guard let urlComponents = URLComponents(string: "http://zcash.flypool.org/api/miner_new/\(walletID)") else {
      let fpError = FPError.api("Can't parse URLs based on RFC 3986 and to construct URLs from this url")
      let errorResult = FPResult<FPData>.Failure(error: fpError)
      DispatchQueue.main.async {
        completion(errorResult)
      }
      
      return
    }
    
    guard let url = urlComponents.url else {
      let fpError = FPError.api("URL from urlComponents is empty")
      let errorResult = FPResult<FPData>.Failure(error: fpError)
      DispatchQueue.main.async {
        completion(errorResult)
      }
      
      return
    }
      
    dataTask = defaultSession.dataTask(with: url) { data, response, error in
      defer { self.dataTask = nil }
        
      if let err = error {
        let fpError = FPError.other(err.localizedDescription)
        let errorResult = FPResult<FPData>.Failure(error: fpError)
        DispatchQueue.main.async {
          completion(errorResult)
        }
        
        return
      }
        
      guard let data = data else {
        let error = FPError.api("Reponse data is empty. We can't fetch data from Flypool API")
        let errorResult = FPResult<FPData>.Failure(error: error)
        DispatchQueue.main.async {
          completion(errorResult)
        }
        
        return
      }
        
      guard let httpResponse = response as? HTTPURLResponse else {
        let error = FPError.api("Can't fetch response data from Flypool API")
        let errorResult = FPResult<FPData>.Failure(error: error)
        DispatchQueue.main.async {
          completion(errorResult)
        }
        
        return
      }
          
      switch httpResponse.statusCode {
        case 200..<300:
          guard let fpData = FPData(data: data) else {
            let error = FPError.other("Can't parse data from Flypool API")
            let errorResult = FPResult<FPData>.Failure(error: error)
            DispatchQueue.main.async {
              completion(errorResult)
            }
            
            return
          }
            
          let result = FPResult.Success(result: fpData)
          DispatchQueue.main.async {
            completion(result)
          }
            
        case 400..<600:
          let error = FPError.api(httpResponse.debugDescription)
          let errorResult = FPResult<FPData>.Failure(error: error)
          DispatchQueue.main.async {
            completion(errorResult)
          }
            
        default:
          let error = FPError.api("unrecognized HTTP status code: \(httpResponse.statusCode)")
          let errorResult = FPResult<FPData>.Failure(error: error)
          DispatchQueue.main.async {
            completion(errorResult)
          }
        }
      } // dataTask
      
      dataTask?.resume()
  }
  
  func fetchWalletID() -> String? {
    return WalletIDStore.getWalletID(from: .flypool)
  }
  
  func fetchWorkers(walletID: String, completion: @escaping ([FPHTMLWorker]?) -> Void) {
    HTMLParser<FPHTMLWorker>.parseWorkersTable(walletID: walletID, completion: completion)
  }
}

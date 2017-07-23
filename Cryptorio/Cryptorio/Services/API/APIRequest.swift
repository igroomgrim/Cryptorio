//
//  APIRequest.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

class APIRequest<Result: FPObject> {
  typealias Callback = (Failable<Data>) -> Void
  
  let client: APIClient
  let callback: Callback?
  let endPoint: APIEndpoint<Result>
  
  var task: URLSessionDataTask?
  
  init(client: APIClient, endPoint: APIEndpoint<Result>, callback: Callback?) {
    self.client = client
    self.callback = callback
    self.endPoint = endPoint
  }
  
  func cancel() {
    task?.cancel()
  }
  
  func start() throws -> Self {
    let requestURL = endPoint.url
    let urlRequest = URLRequest(url: requestURL)
    let dataTask = client.session.dataTask(with: urlRequest, completionHandler: didComplete)
    self.task = dataTask
    dataTask.resume()
    
    return self
  }
  
  fileprivate func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
    guard callback != nil else { return }
    
    if let err = error {
      performCallback(Failable.fail(.other(err.localizedDescription)))
      return
    }
    
    guard let httpResponse = response as? HTTPURLResponse else {
      let err = FPError.other("no error and no response.")
      performCallback(Failable.fail(err))
      return
    }
    
    guard let data = data else {
      let err = FPError.other("empty response.")
      performCallback(Failable.fail(err))
      return
    }
    
    let result: Failable<Data>
   
    switch httpResponse.statusCode {
    case 400..<600:
      let err = FPError.api("api error : \(httpResponse.statusCode)")
      result = Failable.fail(err)
      
    case 200..<300:
      result = Failable.success(data)
        
    default:
      let err = FPError.other("unrecognized HTTP status code: \(httpResponse.statusCode)")
      result = Failable.fail(err)
    }
    
    performCallback(result)
  }
  
  fileprivate func performCallback(_ result: Failable<Data>) {
    guard let cb = callback else { return }
    client.operationQueue.addOperation({ cb(result) })
  }
}

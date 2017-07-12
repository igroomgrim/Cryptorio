//
//  WalletIDStore.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/11/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

enum WalletPool: String {
  case flypool = "flypool"
  case nicehash = "nicehash"
}

class WalletIDStore {
  private func getPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentDirectory = paths[0] as! String
    let path = documentDirectory.appending("/Wallet.plist")
    
    return path
  }
  
  private func getWalletDic() -> NSMutableDictionary? {
    let path = getPath()
    let fileManager = FileManager.default
    if(!fileManager.fileExists(atPath: path)){
      if let bundlePath = Bundle.main.path(forResource: "Wallet", ofType: "plist") {
        do{
          try fileManager.copyItem(atPath: bundlePath, toPath: path)
        }catch{
          print("copy failure.")
          return nil
        }
      }else{
        print("Wallet.plist not found.")
        return nil
      }
    }else{
      print("Wallet.plist already exits at path.")
    }
    
    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    return resultDictionary
  }
  
  func getWalletID(from pool: WalletPool) -> String? {
    guard let walletDic = getWalletDic() else {
      return nil
    }
    
    let walletID = walletDic.object(forKey: pool.rawValue) as? String
    return walletID
  }
  
  func saveWalletID(walletID: String, pool: WalletPool) {
    guard let walletDic = getWalletDic() else {
      return
    }
    
    let path = getPath()
    
    walletDic.setValue(walletID, forKey: pool.rawValue)
    walletDic.write(toFile: path, atomically: true)
  }
}

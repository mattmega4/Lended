//
//  BranchUtility.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 8/9/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

import UIKit
import Fabric
import Branch

class BranchUtility: NSObject {
  
  static let shared = BranchUtility()
  
  func generateBranchLinkFor(promoCode: String, completion: @escaping (_ link: String?) -> Void) {
    
    let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: BranchKeys.promoCodeSlashOne)
    branchUniversalObject.title = BranchKeys.promoCode
    branchUniversalObject.contentDescription = BranchKeys.downloadLynked
    branchUniversalObject.contentMetadata.customMetadata[BranchKeys.code] = promoCode
    // test that ^
    
    
//    branchUniversalObject.addMetadataKey(BranchKeys.code, value: promoCode)
    
    // Old depricated ^
    
    
    //branchUniversalObject.addMetadataKey("property2", value: "red")
    
    let linkProperties: BranchLinkProperties = BranchLinkProperties()
    linkProperties.feature = BranchKeys.code
    
    branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
      completion(url)
    }
  }
  
}

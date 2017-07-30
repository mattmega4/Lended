//
//  TransactionUtility.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Alamofire

class TransactionUtility: NSObject {
  
  static let shared = TransactionUtility()
  
  
  
  func convert(amount: Double, from fromCurrency: String, to toCurrency: String, forDate date: Date, completion: @escaping (_ convertedAmount: Double?, _ error: Error?) -> Void) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    let apiString = BASE_CURRENCY_API_URL + dateString + BASE + fromCurrency
    if let url = URL(string: apiString) {
      let request = Alamofire.request(url)
      request.responseJSON(completionHandler: { (response) in
        if let rateDict = (response.value as? [String : Any])?["rates"] as? [String : Double] {
          if let convertedAmount = rateDict[toCurrency] {
            completion(convertedAmount * amount, nil)
          }
        }
      })
    }
  }
  
}

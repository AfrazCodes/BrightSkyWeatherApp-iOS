//
//  IAPManager.swift
//  brightsky
//
//  Created by Afraz Siddiqui on 9/18/23.
//

import RevenueCat
import Foundation

final class IAPManager {
    static let shared = IAPManager()

    private init() {}

    func isSubscribed(completion: @escaping (Bool) -> Void) {
        Purchases.shared.getCustomerInfo { info, error in
            guard let subscriptions = info?.activeSubscriptions else { return }
            completion(!subscriptions.isEmpty)
        }
    }
}

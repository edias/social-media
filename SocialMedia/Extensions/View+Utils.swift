//
//  View+Utils.swift
//  social-media
//
//  Created by Eduardo Dias on 15/07/21.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func unredacted(when condition: Bool) -> some View {
        if condition {
            unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
    
    @ViewBuilder
    func onError(_ errorType: ErrorType? = nil, retryAction: @escaping () -> Void) -> some View {
        ZStack {
            if let errorType = errorType {
                ErrorView(errorType, retryAction: retryAction)
            } else {
                self
            }
        }
    }
}

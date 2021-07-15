//
//  ErrorView.swift
//  social-media
//
//  Created by Eduardo Dias on 15/07/21.
//

import SwiftUI

enum ErrorType {
    case generic
    case offline
}

struct ErrorView: View {
    
    private var retryAction: () -> Void
    
    @State
    private var errorData: (icon: String, message: String)
    
    init(_ errorType: ErrorType, retryAction: @escaping () -> Void) {
        switch errorType {
            case .offline:
                errorData = (icon: "ErrorOfflineIcon", "Opps...Your internet connection seems off. Please try again.")
            case .generic:
                errorData = (icon: "ErrorIcon", "Opps...An error ocurred. \nPlease try again.")
        }
        self.retryAction = retryAction
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Image(errorData.icon)
                .resizable()
                .foregroundColor(ColorPalette.secondaryGray.opacity(0.5))
                .frame(width: 120, height: 120)
                .padding(.bottom, 40)
            
            Text(errorData.message)
                .font(.body)
                .bold()
                .foregroundColor(ColorPalette.secondaryGray)
                .multilineTextAlignment(.center)
            
            Spacer()
            Button("Try again") {
                retryAction()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .font(.subheadline.weight(.bold))
            .background(Color.red)
            .cornerRadius(35)
            .foregroundColor(Color.white)
            .padding(.bottom, 20)
        }
        .frame(width: 350, alignment: .center)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(.generic, retryAction: {})
    }
}

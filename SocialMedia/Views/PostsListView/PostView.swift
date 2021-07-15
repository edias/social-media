//
//  PostView.swift
//  social-media
//
//  Created by Eduardo Dias on 13/07/21.
//

import SwiftUI

struct PostView: View {
    
    var post: Post
    
    @Binding
    var selection: Int?
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 5) {
            
            Text("\(post.title.capitalized)")
                .lineLimit(2)
                .font(Font.callout.bold())
                .foregroundColor(ColorPalette.primaryGray)
            
            Text("\(post.body.capitalized)")
                .font(.subheadline)
                .foregroundColor(ColorPalette.secondaryGray)
                .padding(.bottom, 20)
            
            Divider().background(ColorPalette.secondaryGray)
        }
        .padding(.top, 10)
        .padding(.bottom, 0)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .onTapGesture { selection = post.id }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let post = Post(id: 0, title: "Title", body: "Body")
            PostView(post: post, selection: .constant(0))
                .previewLayout(.fixed(width: 400, height: 100))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            PostView(post: post, selection: .constant(0))
                .previewLayout(.fixed(width: 400, height: 100))
                .previewDisplayName("Light Mode")
        }
    }
}

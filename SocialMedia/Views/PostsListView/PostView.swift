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
            
            Text("\(post.body.capitalized)")
                .font(.subheadline)
                .foregroundColor(Color.black.opacity(0.7))
            
            HStack { Spacer() }.padding(.top, 3)
        }
        .padding(.top, 10)
        .padding(.bottom, 0)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .onTapGesture { selection = post.id }
        
        Divider().background(Color.gray.opacity(0.1))
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post(id: 0, title: "Title", body: "Body")
        PostView(post: post, selection: .constant(0)).previewLayout(.sizeThatFits)
            .padding()
    }
}

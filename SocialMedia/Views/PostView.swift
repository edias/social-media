//
//  PostView.swift
//  social-media
//
//  Created by Eduardo Dias on 13/07/21.
//

import SwiftUI

struct PostView: View {
    
    var post: Post
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 5){
            
            Text("\(post.title)")
                .lineLimit(2)
                .font(Font.callout.bold())
            
            Text("\(post.body)")
                .font(.caption)
            
            Spacer(minLength: 5)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post(id: 0, title: "Title", body: "Body")
        PostView(post: post).previewLayout(.sizeThatFits)
            .padding()
    }
}

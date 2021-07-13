//
//  PostCommentsView.swift
//  social-media
//
//  Created by Eduardo Dias on 13/07/21.
//

import Combine
import SwiftUI

struct PostCommentsView: View {
    
    @ObservedObject
    private var viewModel = PostCommentsViewModel()
    
    private let padding = CGFloat(15)
    
    var post: Post
    
    var body: some View {
        
        ScrollView {
        
            VStack (alignment: .leading, spacing: 10) {
                
                Text("\(post.title.capitalized)")
                    .font(Font.title3.bold())
                
                Text("\(post.body)")
                    .font(.body)
                    .foregroundColor(Color.black.opacity(0.8))
                
                ForEach(viewModel.comments, id: \.self) { comment in
                    
                    LazyVStack (alignment: .leading, spacing: 5) {
                        
                        Text("\(comment.name)")
                            .font(Font.subheadline.bold())

                        Text("\(comment.body)")
                            .font(.subheadline)
                        
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.top, padding)
            .padding(.leading, padding)
            .padding(.trailing, padding)

        }
        .onAppear { viewModel.fetchComments(post.id) }
        .navigationBarTitle("Comments", displayMode: .inline)
    }
}

struct PostCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentsView(post: Post(id: 1, title: "Title", body: "Body"))
    }
}

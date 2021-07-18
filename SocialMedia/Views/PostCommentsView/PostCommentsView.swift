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
        
        VStack {
            
            SearchBar(searchText: $viewModel.searchText)
                .padding(.top, 10)
            
            ScrollView {
            
                VStack (alignment: .leading, spacing: 10) {
                    
                    Text("\(post.title.capitalized)")
                        .font(Font.title3.bold())
                        .foregroundColor(ColorPalette.primaryGray)
                    
                    Text("\(post.body)")
                        .font(.body)
                        .foregroundColor(ColorPalette.secondaryGray)
                    
                    ForEach(viewModel.comments, id: \.self) { comment in
                        
                        LazyVStack (alignment: .leading, spacing: 5) {
                            
                            Text("\(comment.name)")
                                .font(Font.subheadline.bold())

                            Text("\(comment.body)")
                                .font(.subheadline)
                                .foregroundColor(ColorPalette.primaryGray)
                            
                        }
                        .padding()
                        .background(ColorPalette.secondaryGray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .unredacted(when: viewModel.commentsLoaded)
                }
                .padding(.top, padding)
                .padding(.leading, padding)
                .padding(.trailing, padding)

            }
            .navigationBarTitle("Comments", displayMode: .inline)
        }
        .onAppear { viewModel.loadComments(post.id) }
        .onError(viewModel.errorType, retryAction: { viewModel.loadComments(post.id) })
    }
}

struct PostCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentsView(post: Post(id: 1, title: "Title", body: "Body")).previewLayout(.fixed(width: 400, height: 300))
            .padding()
    }
}

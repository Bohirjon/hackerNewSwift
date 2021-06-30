//
//  StoryView.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 12/06/21.
//

import SwiftUI

struct StoryView: View {
    @ObservedObject private var viewModel: StoryViewCellViewModel
    @State private var story : Story? = nil
    
    init(storyId: Int) {
        viewModel = StoryViewCellViewModel(id: storyId, hackerApi: HackerNewsApi())
        viewModel.fetch()
    }
    
    var body: some View {
        if viewModel.loading {
            loadingView
        } else {
            if  viewModel.story != nil {
                dataView
            } else {
                errorView
            }
        }
    }
    
    var dataView: some View {
        VStack(spacing: .some(7.0)) {
            HStack {
                Text(viewModel.story!.title)
                    .font(.headline)
                    .bold()
                Spacer()
            }
            HStack {
                Text(viewModel.story!.descendants)
                    .foregroundColor(.gray.opacity(0.8))
                Spacer()
                Text("10h - by")
                Text("\(viewModel.story!.by)")
                    .foregroundColor(.blue)
            }
            
            HStack {
                Group {
                    Image(systemName: "hand.thumbsup")
                    Text(viewModel.story!.score.description)
                        .padding(.trailing)
                }
                .foregroundColor(.blue)
                
                Group {
                    Image(systemName: "bubble.left")
                    Text(viewModel.story!.kids.count.description)
                }
                .foregroundColor(.orange)
                
                Spacer()
                Image(systemName: "bookmark")
            }
        }
        .padding()
    }
    
    var errorView : some View {
        Text("\(viewModel.error.debugDescription)")
    }
    
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(LinearProgressViewStyle())
    }
    
}

class StoryViewCellViewModel: ObservableObject {
    let id: Int
    let hackerApi: HackerNewsApi
    
    @Published var story: Story? = nil
    @Published var error: Error? = nil
    @Published var loading: Bool = false
    
    init(id: Int, hackerApi: HackerNewsApi) {
        self.id = id
        self.hackerApi = hackerApi
    }
    func fetch() {
        hackerApi.fetchArticle(id: id) { story, error in
            if let safeError = error {
                self.error = safeError
            }
            
            if let safeStory = story {
                self.story = safeStory
            }
        }
    }
    
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView(storyId: 12)
    }
}

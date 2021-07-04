//
//  StoryView.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 12/06/21.
//

import SwiftUI

struct StoryView: View {
    @ObservedObject private var viewModel: StoryViewCellViewModel

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
        NavigationLink(destination: StoryDetailView(stringUrl: viewModel.story!.url!)) {
            VStack(spacing: .some(7.0)) {
                HStack {
                    Text(viewModel.story!.title)
                        .foregroundColor(.black)
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                HStack {
                    if let descendants = viewModel.story!.descendants {
                        Text(descendants.description)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    Spacer()
                    Text("10h - by")
                        .foregroundColor(.black)
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
                        Text(viewModel.story!.kids != nil ? viewModel.story!.kids!.count.description : "0")
                    }
                    .foregroundColor(.orange)
                    
                    Spacer()
                    Image(systemName: "bookmark")
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
    }
    
    var errorView : some View {
        print("error occurred \(viewModel.error.debugDescription)")
        return Text("\(viewModel.error.debugDescription)")
    }
    
    var loadingView: some View {
        VStack {
            EmptyView()
                .background(Color.gray.opacity(0.8))
                .foregroundColor(.red)
                .frame(width: 100, height: 20)
                .font(.headline)
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle())
        }
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
        loading = true
        hackerApi.fetchArticle(id: id) { story, error in
            DispatchQueue.main.async {
                if let safeError = error {
                    self.error = safeError
                }
                if let safeStory = story {
                    self.story = safeStory
                }
                self.loading = false
            }
        }
    }
    
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView(storyId: 12)
    }
}

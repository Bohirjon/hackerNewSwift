//
//  MainVieWModel.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 10/06/21.
//

import Foundation

class MainViewModel: ObservableObject, HackerNewsApiDelegate {
    
    var hackerNewsApi: HackerNewsProtocol
    @Published var ids : [Int]? = nil
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    
    init(hackerNewsApi: HackerNewsApi) {
        self.hackerNewsApi = hackerNewsApi
        self.hackerNewsApi.hackerNewsDelegate = self
    }
    
    
    func fetchIds() {
        hackerNewsApi.fetchIds();
    }
    
    func onIdsFetched(ids: [Int]) {
        DispatchQueue.main.async {
            self.ids = ids
        }
    }
    
    func fetchStory(id: Int, onStoryFetched: @escaping (Story) -> Void, onFetchingFailed: @escaping (Error)-> Void) {
        hackerNewsApi.fetchArticle(id: id) { Story, Error in
            if let safeError = Error {
                onFetchingFailed(safeError)
            }
            
            if let safeStory = Story {
                onStoryFetched(safeStory)
            }
        }
    }
    
    func onIdsFetchFailed(error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func onStoryFetched(story: Story) {
        
    }
    
    func onStoryFetchFailed(error: Error) {
        
    }
    
}

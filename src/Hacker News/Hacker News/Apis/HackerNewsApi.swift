//
//  HackerNewsApi.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 17/01/21.
//

import Foundation

protocol HackerNewsApiDelegate {
    func onIdsFetched (ids: [Int])
    func onIdsFetchFailed(error: Error)
    
    func onStoryFetched(story: Story)
    func onStoryFetchFailed(error: Error)
}

protocol HackerNewsProtocol {
    var hackerNewsDelegate: HackerNewsApiDelegate? {get set}
    func fetchIds()
    func fetchArticle(id: Int)
    func fetchArticle(id: Int, onFetched: @escaping (Story?, Error?)->Void)
}


class HackerNewsApi: HackerNewsProtocol {
    
    var hackerNewsDelegate: HackerNewsApiDelegate?
    
    func fetchIds() {
        if let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let err = error {
                    self.hackerNewsDelegate?.onIdsFetchFailed(error: ArgumentError.argumentError("there was an error while \(err.localizedDescription)"))
                } else {
                    if let safeData = data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let ids = try jsonDecoder.decode([Int].self, from: safeData)
                            self.hackerNewsDelegate?.onIdsFetched(ids: ids)
                            
                        } catch let error {
                            self.hackerNewsDelegate?.onIdsFetchFailed(error: error)
                        }
                    }
                    else {
                        self.hackerNewsDelegate?.onIdsFetchFailed(error: ArgumentError.argumentError("Ids were empty or null"))
                    }
                }
            }
            .resume()
        } else {
            hackerNewsDelegate?.onIdsFetchFailed(error: ArgumentError.argumentError("url was wrong could not parse"))
        }
    }
    
    func fetchArticle(id: Int) {
        if let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id.description).json?print=pretty") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let safeError = error {
                    self.hackerNewsDelegate?.onStoryFetchFailed(error: ArgumentError.argumentError("Fetching story failed: \(safeError.localizedDescription)"))
                } else {
                    if let safeData = data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let story = try jsonDecoder.decode(Story.self, from: safeData)
                            self.hackerNewsDelegate?.onStoryFetched(story: story)
                        } catch let err {
                            self.hackerNewsDelegate?.onStoryFetchFailed(error: ArgumentError.argumentError("Failed while decoding data: \(err.localizedDescription)"))
                        }
                        
                    } else {
                        self.hackerNewsDelegate?.onStoryFetchFailed(error: ArgumentError.argumentError("fetched data was wrong"))
                    }
                }
            }
            .resume()
        } else {
            self.hackerNewsDelegate?.onStoryFetchFailed(error: ArgumentError.argumentError("Url was wrong!"))
        }
    }
    
    func fetchArticle(id: Int, onFetched: @escaping (Story?, Error?) -> Void) {
        let stringUrl = "https://hacker-news.firebaseio.com/v0/item/\(id.description).json?print=pretty"
        
        guard let url = URL(string: stringUrl ) else {
            onFetched(nil, ArgumentError.argumentError("Url was wrong"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                onFetched(nil, ArgumentError.argumentError("\(error.localizedDescription)"))
                return
            }
            
            if let safeData = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let story = try jsonDecoder.decode(Story.self, from: safeData)
                    onFetched(story, nil)
                } catch let parseError {
                    print(parseError)
                    onFetched(nil, parseError)
                }
                
            } else {
                onFetched(nil, ArgumentError.argumentError("Could not fetch the data"))
            }
            
        }
        .resume()
    }
}

